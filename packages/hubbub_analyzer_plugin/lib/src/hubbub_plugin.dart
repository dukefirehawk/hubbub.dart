import 'package:analyzer/context/context_root.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/src/context/builder.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer/src/dart/analysis/performance_logger.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer_plugin/plugin/completion_mixin.dart';
import 'package:analyzer_plugin/plugin/navigation_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_constants.dart' as plugin;
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:analyzer_plugin/src/utilities/completion/completion_core.dart';
import 'package:analyzer_plugin/src/utilities/navigation/navigation.dart';
import 'package:analyzer_plugin/utilities/analyzer_converter.dart';
import 'package:analyzer_plugin/utilities/completion/completion_core.dart';
import 'package:analyzer_plugin/utilities/navigation/navigation.dart';
import 'hubbub_driver.dart';

class HubbubPlugin extends plugin.ServerPlugin {
  HubbubPlugin(ResourceProvider provider) : super(provider);

  @override
  List<String> get fileGlobsToAnalyze => <String>['**/*.dartx', '**/*.hubbub'];

  @override
  String get name => 'hubbub_analyzer_plugin';

  @override
  String get version => '0.0.1';

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final root = ContextRoot(contextRoot.root, contextRoot.exclude,
        pathContext: resourceProvider.pathContext)
      ..optionsFilePath = contextRoot.optionsFile;

    final logger = PerformanceLog(StringBuffer());
    final builder = ContextBuilder(resourceProvider, sdkManager, null)
      ..analysisDriverScheduler = (AnalysisDriverScheduler(logger)..start())
      ..byteStore = byteStore
      ..performanceLog = logger
      ..fileContentOverlay = fileContentOverlay;

    final dartDriver = builder.buildDriver(root)
      ..results.listen((_) {}) // Consume the stream, otherwise we leak.
      ..exceptions.listen((_) {}); // Consume the stream, otherwise we leak.

    // At this point, we've set up a Dart analyzer.
    // The goal now is just to:
    //   * Listen for Hubbub changes
    //   * Compile on-the-fly
    //   * Feed the compiled files into the analyzer.

    return HubbubDriver(dartDriver);
  }

  @override
  void sendNotificationsForSubscriptions(
      Map<String, List<plugin.AnalysisService>> subscriptions) {
    // subscriptions.forEach((filePath, services) {
    //   final driver = angularDriverForPath(filePath);
    //   if (driver == null) {
    //     return;
    //   }

    //   // Kick off a full reanalysis of files with subscriptions. This will add
    //   // a resolved result to the stream which will send the new necessary
    //   // notifications.
    //   filePath.endsWith('.dart')
    //       ? driver.requestDartResult(filePath)
    //       : driver.requestHtmlResult(filePath);
    // });
  }
}
