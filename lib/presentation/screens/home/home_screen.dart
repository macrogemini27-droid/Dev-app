import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/presentation/blocs/connection/connection_bloc.dart' as connection;
import 'package:claude_code_mobile/presentation/screens/settings/settings_screen.dart';
import 'package:claude_code_mobile/presentation/screens/settings/widgets/ssh_config_form.dart';
import 'package:claude_code_mobile/presentation/screens/chat/modern_chat_screen.dart';
import 'package:claude_code_mobile/domain/entities/ssh_config.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved configs on startup
    context.read<connection.ConnectionBloc>().add(connection.LoadSavedConfigsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<connection.ConnectionBloc, connection.ConnectionState>(
      listener: (context, state) {
        if (state is connection.ConnectionConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Connected to ${state.config.name}'),
                  ),
                ],
              ),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is connection.ConnectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Connection failed: ${state.message}'),
                  ),
                ],
              ),
              backgroundColor: AppTheme.errorColor,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  if (state.config != null) {
                    context.read<connection.ConnectionBloc>().add(
                          connection.ConnectToServerEvent(config: state.config!),
                        );
                  }
                },
              ),
            ),
          );
        } else if (state is connection.ConnectionDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cloud_off, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Disconnected from server'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Claude Code Mobile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildConnectionStatus(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
        floatingActionButton: _buildFAB(context),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        Color statusColor;
        String statusText;
        IconData statusIcon;
        Widget? actionButton;

        if (state is connection.ConnectionConnected) {
          statusColor = AppTheme.successColor;
          statusText = 'Connected to ${state.config.name}';
          statusIcon = Icons.check_circle;
          actionButton = TextButton.icon(
            onPressed: () {
              context.read<connection.ConnectionBloc>().add(
                    const connection.DisconnectFromServerEvent(),
                  );
            },
            icon: const Icon(Icons.power_settings_new, size: 18),
            label: const Text('Disconnect'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.successColor,
            ),
          );
        } else if (state is connection.ConnectionConnecting) {
          statusColor = AppTheme.warningColor;
          statusText = 'Connecting to ${state.config.name}...';
          statusIcon = Icons.sync;
          actionButton = const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (state is connection.ConnectionError) {
          statusColor = AppTheme.errorColor;
          statusText = 'Connection failed';
          statusIcon = Icons.error;
          actionButton = TextButton.icon(
            onPressed: () {
              if (state.config != null) {
                context.read<connection.ConnectionBloc>().add(
                      connection.ConnectToServerEvent(config: state.config!),
                    );
              }
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
          );
        } else {
          statusColor = AppTheme.textTertiaryColor;
          statusText = 'Not connected';
          statusIcon = Icons.cloud_off;
          actionButton = null;
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
              if (actionButton != null) actionButton,
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        if (state is connection.ConnectionLoadingConfigs) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is connection.ConnectionConfigsLoaded) {
          if (state.configs.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildServerList(context, state.configs);
        }

        if (state is connection.ConnectionConnected) {
          // Show sessions when connected
          return _buildSessionList(context, state.config);
        }

        // Default: show saved servers
        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 80,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'No Servers Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first SSH server to get started',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddServerDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Server'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerList(BuildContext context, List<SSHConfig> configs) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        final connectedConfig = state is connection.ConnectionConnected ? state.config : null;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: configs.length,
          itemBuilder: (context, index) {
            final config = configs[index];
            final isConnected = connectedConfig?.id == config.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isConnected ? AppTheme.successColor.withOpacity(0.2) : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isConnected ? Icons.cloud_done : Icons.dns,
                    color: isConnected ? AppTheme.successColor : AppTheme.primaryColor,
                  ),
                ),
                title: Text(
                  config.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${config.username}@${config.host}:${config.port}',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 13,
                      ),
                    ),
                    if (isConnected)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'CONNECTED',
                            style: TextStyle(
                              color: AppTheme.successColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'connect') {
                      context.read<connection.ConnectionBloc>().add(
                            connection.ConnectToServerEvent(config: config),
                          );
                    } else if (value == 'disconnect') {
                      context.read<connection.ConnectionBloc>().add(
                            const connection.DisconnectFromServerEvent(),
                          );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, config);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!isConnected)
                      const PopupMenuItem(
                        value: 'connect',
                        child: Row(
                          children: [
                            Icon(Icons.power_settings_new, size: 20),
                            SizedBox(width: 12),
                            Text('Connect'),
                          ],
                        ),
                      ),
                    if (isConnected)
                      const PopupMenuItem(
                        value: 'disconnect',
                        child: Row(
                          children: [
                            Icon(Icons.power_off, size: 20),
                            SizedBox(width: 12),
                            Text('Disconnect'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: isConnected
                    ? null
                    : () {
                        context.read<connection.ConnectionBloc>().add(
                              connection.ConnectToServerEvent(config: config),
                            );
                      },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSessionList(BuildContext context, SSHConfig config) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'No Sessions Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Connected to ${config.name}\nCreate a new session to start coding',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFAB(BuildContext context) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        if (state is connection.ConnectionConnected) {
          return FloatingActionButton.extended(
            onPressed: () {
              _navigateToChat(context, state.config);
            },
            icon: const Icon(Icons.add),
            label: const Text('New Session'),
          );
        }

        return FloatingActionButton(
          onPressed: () => _showAddServerDialog(context),
          child: const Icon(Icons.add),
        );
      },
    );
  }

  void _navigateToChat(BuildContext context, SSHConfig config) {
    // Generate a new session ID
    const uuid = Uuid();
    final sessionId = uuid.v4();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModernChatScreen(sessionId: sessionId),
      ),
    );
  }

  void _showAddServerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: const SSHConfigForm(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SSHConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Server'),
        content: Text('Are you sure you want to delete "${config.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<connection.ConnectionBloc>().add(
                    connection.DeleteConfigEvent(configId: config.id),
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
