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

class HubbubDriver extends AnalysisDriverGeneric {
  final AnalysisDriver dartDriver;

  HubbubDriver(this.dartDriver);

  @override
  void addFile(String path) => dartDriver.addFile(path);

  @override
  void dispose() => dartDriver.dispose();

  @override
  bool get hasFilesToAnalyze => dartDriver.hasFilesToAnalyze;

  @override
  Future<void> performWork() => dartDriver.performWork();

  @override
  void set priorityFiles(List<String> priorityPaths) {
    dartDriver.priorityFiles = priorityPaths;
  }

  @override
  AnalysisDriverPriority get workPriority => dartDriver.workPriority;
}
