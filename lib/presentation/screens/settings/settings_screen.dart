import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/presentation/blocs/connection/connection_bloc.dart' as connection;
import 'package:claude_code_mobile/presentation/screens/settings/widgets/ssh_config_form.dart';
import 'package:claude_code_mobile/presentation/screens/settings/provider_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved SSH configs when screen opens
    context.read<connection.ConnectionBloc>().add(connection.LoadSavedConfigsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'AI Providers',
            children: [
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('Manage Providers'),
                subtitle: const Text('Configure Anthropic, Gemini, Groq, and custom providers'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProviderManagementScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'SSH Connections',
            children: [
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Add SSH Connection'),
                subtitle: const Text('Configure a new SSH server'),
                onTap: () {
                  _showAddConnectionDialog(context);
                },
              ),
              const Divider(),
              _buildSavedConnections(context),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('1.0.0+1'),
              ),
              const ListTile(
                leading: Icon(Icons.code),
                title: Text('Claude Code Mobile'),
                subtitle: Text('AI-powered coding assistant'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            border: Border(
              top: BorderSide(color: AppTheme.borderColor),
              bottom: BorderSide(color: AppTheme.borderColor),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSavedConnections(BuildContext context) {
    return BlocBuilder<connection.ConnectionBloc, connection.ConnectionState>(
      builder: (context, state) {
        if (state is connection.ConnectionLoadingConfigs) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is connection.ConnectionConfigsLoaded) {
          if (state.configs.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No saved connections',
                  style: TextStyle(color: AppTheme.textTertiaryColor),
                ),
              ),
            );
          }

          return Column(
            children: state.configs.map((config) {
              return ListTile(
                leading: const Icon(Icons.dns),
                title: Text(config.name),
                subtitle: Text('${config.username}@${config.host}:${config.port}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, config);
                  },
                ),
                onTap: () {
                  context.read<connection.ConnectionBloc>().add(
                        connection.ConnectToServerEvent(config: config),
                      );
                  Navigator.pop(context);
                },
              );
            }).toList(),
          );
        }

        // For other states (Connected, Disconnected, etc.), try to load configs
        if (state is connection.ConnectionConnected ||
            state is connection.ConnectionDisconnected ||
            state is connection.ConnectionInitial) {
          // Trigger load if not already loading
          Future.microtask(() {
            if (state is! connection.ConnectionLoadingConfigs) {
              context.read<connection.ConnectionBloc>().add(
                    connection.LoadSavedConfigsEvent(),
                  );
            }
          });
        }

        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No saved connections',
              style: TextStyle(color: AppTheme.textTertiaryColor),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Connection'),
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

  void _showAddConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const SSHConfigForm(),
        ),
      ),
    );
  }
}
