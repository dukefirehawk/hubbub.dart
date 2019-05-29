import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc_2;
import 'package:package_resolver/package_resolver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:stream_channel/isolate_channel.dart';
import 'package:stream_channel/stream_channel.dart';
import 'parse.dart';
import 'rpc.dart';

/// Facilitates interfacing with Hubbub plugins via JSON RPC 2.0.
class TransformationEngine {
  /// A [RegExp] for detecting Hubbub plugins.
  static final RegExp hubbubPluginRegex = RegExp(r'^hubbub_plugin_([^$]+)');

  /// A [RegExp] for detecting Hubbub plugins.
  static final RegExp hubbubPresetRegex = RegExp(r'^hubbub_preset_([^$]+)');

  /// A [List] of connections to Hubbub plugins.
  final remotes = <RemoteHubbubTransformer>[];
  bool _init = false;

  /// Closes all current connections, and resets the engine.
  Future<void> close() async {
    while (remotes.isNotEmpty) {
      var remote = remotes.removeAt(0);
      await remote.close();
    }

    _init = false;
  }

  /// Opens connnections to all available plugins.
  Future<void> initialize({PackageResolver resolver}) async {
    if (!_init) {
      resolver ??= PackageResolver.current;

      // Find all hubbub_plugin and hubbub_preset, etc.

      // First, check if we have a .hubbubrc.
      // TODO: Do we even need to check for a .hubbubrc?

      // If we don't have a .hubbubrc, then search the .packages file.
      await loadPackageConfigMap(await resolver.packageConfigMap, resolver);

      // Now that we've loaded all the plugins, start them all.
      for (var r in remotes) {
        await r.start();
      }

      _init = true;
    }
  }

  /// Loads a plugins found via the [resolver].
  Future<void> loadPackageConfigMap(
      Map<String, Uri> packages, PackageResolver resolver) async {
    for (var entry in packages.entries) {
      // If there is no scheme, this is the current package.
      if (!entry.value.hasScheme) {
        var pkgUri = Uri.parse('package:${entry.key}/tool/hubbub_plugin.dart');
        var hubbubPluginUri = await resolver.resolveUri(pkgUri);
        var hubbubPluginFile = File.fromUri(hubbubPluginUri);
        if (await hubbubPluginFile.exists()) {
          remotes.add(RemoteHubbubTransformer(hubbubPluginUri));
        }
      }

      var pluginMatch = hubbubPluginRegex.firstMatch(entry.key);
      var presetMatch = hubbubPresetRegex.firstMatch(entry.key);

      if (pluginMatch != null) {
        remotes.add(await loadPlugin(pluginMatch[1], resolver));
      } else if (presetMatch != null) {
        await loadPreset(presetMatch[1], resolver);
      }
    }
  }

  /// Loads the plugin with the given [name] (with the leading `hubbub_plugin_` removed).
  Future<RemoteHubbubTransformer> loadPlugin(
      String name, PackageResolver resolver) async {
    // Search for a hubbub_plugin.dart.
    var pkgUri = Uri.parse('package:hubbub_plugin_$name/hubbub_plugin.dart');
    var hubbubPluginUri = await resolver.resolveUri(pkgUri);
    var hubbubPluginFile = File.fromUri(hubbubPluginUri);
    if (!await hubbubPluginFile.exists()) {
      throw StateError(
          'Cannot load plugin `$name`: file ${hubbubPluginFile.path} does not exist.');
    }
    return RemoteHubbubTransformer(hubbubPluginUri);
  }

  /// Loads the preset with the given [name] (with the leading `hubbub_preset_` removed).
  Future<void> loadPreset(String name, PackageResolver resolver) async {
    var rootDir = Directory(await resolver.packagePath('hubbub_preset_$name'));
    var pubspecFile = File.fromUri(rootDir.uri.resolve('pubspec.yaml'));
    var pubspec = Pubspec.parse(await pubspecFile.readAsString(),
        sourceUrl: pubspecFile.uri, lenient: true);
    // Load all plugins/presets.
    var packages = <String, Uri>{};
    for (var package in pubspec.dependencies.keys) {
      if (hubbubPluginRegex.hasMatch(package) ||
          hubbubPresetRegex.hasMatch(package)) {
        packages[package] = await resolver.packagePath(package).then(Uri.parse);
      }
    }

    await loadPackageConfigMap(packages, resolver);
  }
}

/// Interfaces with a Hubbub plugin via JSON RPC 2.0.
class RemoteHubbubTransformer {
  final ReceivePort recv = ReceivePort();
  final Uri uri;

  StreamChannel _channel;
  json_rpc_2.Client _client;
  Isolate _isolate;

  RemoteHubbubTransformer(this.uri);

  /// Starts the plugin in another [Isolate].
  Future<void> start() async {
    _isolate = await Isolate.spawnUri(uri, [], recv.sendPort);
    _channel = IsolateChannel.connectReceive(recv);
    _client = json_rpc_2.Client.withoutJson(_channel);
  }

  /// Invokes the remote transformer.
  Future<CompilationUnit> transform(
      String filename, CompilationUnit unit) async {
    var source = RemoteHubbubSource(filename, unit.toSource());
    var res = await _client.sendRequest(hubbubMethod, source.toJson());
    var result = RemoteHubbubResult.fromMap(res as Map);
    return parseCompilationUnit(result.result, name: filename);
  }

  /// Closes the connection.
  Future<void> close() async {
    await _client.close();
    recv.close();
    _isolate.kill();
  }
}