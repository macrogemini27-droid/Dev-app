import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/presentation/blocs/connection/connection_bloc.dart' as connection;
import 'package:claude_code_mobile/presentation/screens/settings/widgets/ssh_config_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        // TODO: Load saved connections from storage
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
