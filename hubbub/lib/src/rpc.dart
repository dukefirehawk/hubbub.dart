import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc_2;
import 'package:stream_channel/isolate_channel.dart';
import 'parse.dart';

/// The JSON-RPC 2.0 method used by Hubbub.
const String hubbubMethod = 'hubbub';

/// Chains together multiple [transformers].
Future<CompilationUnit> Function(CompilationUnit) chainTransformers(
    Iterable<FutureOr<CompilationUnit> Function(CompilationUnit)>
        transformers) {
  return (unit) async {
    for (var t in transformers) {
      unit = await t(unit);
    }

    return unit;
  };
}

/// Listens for RPC requests, and transforms Hubbub on-the-fly.
Future<void> hubbub(SendPort sendPort,
    FutureOr<CompilationUnit> Function(CompilationUnit) transformer) {
  return hubbubRaw(sendPort, (source) async {
    var unit =
        await parseCompilationUnit(source.contents, name: source.filename);
    unit = await transformer(unit);
    return unit.toSource();
  });
}

/// Listens for RPC requests, and transforms Hubbub on-the-fly using a custom
/// [transformer].
Future<void> hubbubRaw(SendPort sendPort,
    FutureOr<String> Function(RemoteHubbubSource) transformer) async {
  if (sendPort == null) {
    stderr.writeln('Enter some Hubbub code. Press CTRL^D to end input.');
    var contents = await stdin.transform(utf8.decoder).join();
    var source = RemoteHubbubSource('stdin', contents);
    var result = await transformer(source);
    try {
      print(DartFormatter().format(result));
    } catch (_) {
      print(result);
    }
  } else {
    var channel = IsolateChannel.connectSend(sendPort);
    var server = json_rpc_2.Server.withoutJson(channel);
    server.registerMethod(hubbubMethod, (json_rpc_2.Parameters p) async {
      var source = RemoteHubbubSource.fromJsonRpc2(p);
      var result = await transformer(source);
      return RemoteHubbubResult(result).toJson();
    });
    await server.listen();
  }
}

/// A request to process Hubbub sources.
class RemoteHubbubSource {
  final String contents;
  final String filename;

  RemoteHubbubSource(this.filename, this.contents);

  factory RemoteHubbubSource.fromJsonRpc2(json_rpc_2.Parameters p) {
    return RemoteHubbubSource(p['filename'].asString, p['contents'].asString);
  }

  Map<String, String> toJson() {
    return {'contents': contents, 'filename': filename};
  }
}

/// The result of processing a Hubbub source.
class RemoteHubbubResult {
  final String result;

  RemoteHubbubResult(this.result);

  factory RemoteHubbubResult.fromJsonRpc2(json_rpc_2.Parameters p) {
    return RemoteHubbubResult(p['result'].asString);
  }

  factory RemoteHubbubResult.fromMap(Map m) {
    return RemoteHubbubResult.fromJsonRpc2(
        json_rpc_2.Parameters(hubbubMethod, m));
  }

  Map<String, String> toJson() {
    return {'result': result};
  }
}
