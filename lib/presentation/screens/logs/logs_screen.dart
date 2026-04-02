import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/theme/app_theme.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final _logger = AppLogger();
  List<String> _logs = [];
  bool _autoScroll = true;
  final ScrollController _scrollController = ScrollController();
  String _filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadLogs() {
    setState(() {
      _logs = _logger.getLogs();
    });
    if (_autoScroll && _logs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  List<String> _getFilteredLogs() {
    if (_filter == 'ALL') return _logs;
    return _logs.where((log) => log.contains(_filter)).toList();
  }

  Color _getLogColor(String log) {
    if (log.contains('ERROR') || log.contains('❌')) {
      return Colors.red.shade300;
    } else if (log.contains('WARNING') || log.contains('⚠️')) {
      return Colors.orange.shade300;
    } else if (log.contains('INFO') || log.contains('ℹ️')) {
      return Colors.blue.shade300;
    } else if (log.contains('DEBUG') || log.contains('🐛')) {
      return Colors.grey.shade400;
    }
    return AppTheme.textPrimaryColor;
  }

  Future<void> _copyAllLogs() async {
    final logsText = await _logger.getLogsAsString();
    await Clipboard.setData(ClipboardData(text: logsText));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareLogs() async {
    final logsText = await _logger.getLogsAsString();
    await Share.share(
      logsText,
      subject: 'App Logs - ${DateTime.now().toString()}',
    );
  }

  Future<void> _shareLogFile() async {
    final logFile = await _logger.getLogFile();
    if (logFile != null && await logFile.exists()) {
      await Share.shareXFiles(
        [XFile(logFile.path)],
        subject: 'App Log File - ${DateTime.now().toString()}',
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No log file available')),
        );
      }
    }
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Are you sure you want to clear all logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _logger.clearLogs();
              setState(() {
                _logs = [];
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _getFilteredLogs();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Application Logs'),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ALL', child: Text('All Logs')),
              const PopupMenuItem(value: 'ERROR', child: Text('Errors Only')),
              const PopupMenuItem(value: 'WARNING', child: Text('Warnings Only')),
              const PopupMenuItem(value: 'INFO', child: Text('Info Only')),
              const PopupMenuItem(value: 'DEBUG', child: Text('Debug Only')),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  _copyAllLogs();
                  break;
                case 'share':
                  _shareLogs();
                  break;
                case 'share_file':
                  _shareLogFile();
                  break;
                case 'clear':
                  _clearLogs();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 20),
                    SizedBox(width: 8),
                    Text('Copy All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 8),
                    Text('Share Logs'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share_file',
                child: Row(
                  children: [
                    Icon(Icons.file_upload, size: 20),
                    SizedBox(width: 8),
                    Text('Share Log File'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear Logs', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.surfaceColor,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${filteredLogs.length} logs',
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Auto-scroll',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    Switch(
                      value: _autoScroll,
                      onChanged: (value) {
                        setState(() {
                          _autoScroll = value;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs available',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: log));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Log entry copied'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border(
                              left: BorderSide(
                                color: _getLogColor(log),
                                width: 3,
                              ),
                            ),
                          ),
                          child: SelectableText(
                            log,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: _getLogColor(log),
                              height: 1.4,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: filteredLogs.isNotEmpty
          ? FloatingActionButton(
              onPressed: _copyAllLogs,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.copy_all),
            )
          : null,
    );
  }
}
