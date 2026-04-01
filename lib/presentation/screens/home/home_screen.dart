import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/presentation/blocs/connection/connection_bloc.dart' as connection;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claude Code Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildConnectionStatus(context),
          Expanded(
            child: _buildSessionList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewSessionDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Session'),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        Color statusColor;
        String statusText;
        IconData statusIcon;

        if (state is connection.ConnectionConnected) {
          statusColor = AppTheme.successColor;
          statusText = 'Connected to ${state.config.name}';
          statusIcon = Icons.check_circle;
        } else if (state is connection.ConnectionConnecting) {
          statusColor = AppTheme.warningColor;
          statusText = 'Connecting...';
          statusIcon = Icons.sync;
        } else if (state is connection.ConnectionError) {
          statusColor = AppTheme.errorColor;
          statusText = 'Connection failed';
          statusIcon = Icons.error;
        } else {
          statusColor = AppTheme.textTertiaryColor;
          statusText = 'Not connected';
          statusIcon = Icons.cloud_off;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (state is connection.ConnectionConnected)
                TextButton(
                  onPressed: () {
                    context.read<connection.ConnectionBloc>().add(
                          const connection.DisconnectFromServerEvent(),
                        );
                  },
                  child: const Text('Disconnect'),
                ),
              if (state is connection.ConnectionDisconnected || state is connection.ConnectionError)
                TextButton(
                  onPressed: () {
                    _showConnectionDialog(context);
                  },
                  child: const Text('Connect'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionList(BuildContext context) {
    // TODO: Implement session list with real data
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppTheme.textTertiaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new session to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiaryColor,
                ),
          ),
        ],
      ),
    );
  }

  void _showNewSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Session'),
        content: const Text(
          'Please connect to a server first to create a new session.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showConnectionDialog(context);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showConnectionDialog(BuildContext context) {
    // TODO: Implement connection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect to Server'),
        content: const Text('Connection dialog coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
