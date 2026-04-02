import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  
  late Logger _logger;
  final List<String> _logBuffer = [];
  final int _maxBufferSize = 1000;
  File? _logFile;
  
  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: false,
        printEmojis: false,
        printTime: true,
      ),
      output: _CustomOutput(this),
    );
    _initLogFile();
  }

  Future<void> _initLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFile = File('${logsDir.path}/app_log_$dateStr.txt');
    } catch (e) {
      print('Failed to initialize log file: $e');
    }
  }

  void _addToBuffer(String message) {
    final timestamp = DateFormat('HH:mm:ss.SSS').format(DateTime.now());
    final logEntry = '[$timestamp] $message';
    
    _logBuffer.add(logEntry);
    if (_logBuffer.length > _maxBufferSize) {
      _logBuffer.removeAt(0);
    }
    
    _writeToFile(logEntry);
  }

  Future<void> _writeToFile(String message) async {
    try {
      if (_logFile != null) {
        await _logFile!.writeAsString(
          '$message\n',
          mode: FileMode.append,
        );
      }
    } catch (e) {
      print('Failed to write to log file: $e');
    }
  }

  void debug(String message, {String? tag}) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    _logger.d(taggedMessage);
  }

  void info(String message, {String? tag}) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    _logger.i(taggedMessage);
  }

  void warning(String message, {String? tag}) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    _logger.w(taggedMessage);
  }

  void error(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    final taggedMessage = tag != null ? '[$tag] $message' : message;
    _logger.e(taggedMessage, error: error, stackTrace: stackTrace);
  }

  List<String> getLogs() {
    return List.unmodifiable(_logBuffer);
  }

  Future<String> getLogsAsString() async {
    return _logBuffer.join('\n');
  }

  Future<File?> getLogFile() async {
    return _logFile;
  }

  void clearLogs() {
    _logBuffer.clear();
    _logFile?.writeAsStringSync('');
  }
}

class _CustomOutput extends LogOutput {
  final AppLogger appLogger;

  _CustomOutput(this.appLogger);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      appLogger._addToBuffer(line);
      print(line);
    }
  }
}
