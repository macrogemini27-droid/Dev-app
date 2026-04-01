import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/provider_config.dart';
import '../../blocs/provider/provider_bloc.dart';

class ProviderManagementScreen extends StatefulWidget {
  const ProviderManagementScreen({super.key});

  @override
  State<ProviderManagementScreen> createState() => _ProviderManagementScreenState();
}

class _ProviderManagementScreenState extends State<ProviderManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderBloc>().add(LoadProvidersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Providers'),
      ),
      body: BlocBuilder<ProviderBloc, ProviderState>(
        builder: (context, state) {
          if (state is ProviderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProviderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProviderBloc>().add(LoadProvidersEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProviderLoaded) {
            if (state.providers.isEmpty) {
              return _buildEmptyState();
            }
            return _buildProviderList(state.providers);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProviderDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Provider'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 80, color: AppTheme.textTertiaryColor),
            const SizedBox(height: 24),
            Text(
              'No Providers Configured',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add an AI provider to start using Claude Code Mobile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddProviderDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Provider'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderList(List<ProviderConfig> providers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: provider.isDefault
                    ? AppTheme.primaryColor.withOpacity(0.2)
                    : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getProviderIcon(provider.type),
                color: provider.isDefault ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              ),
            ),
            title: Row(
              children: [
                Text(
                  provider.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (provider.isDefault) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  provider.type.displayName,
                  style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                ),
                if (provider.customModelName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Model: ${provider.customModelName}',
                    style: TextStyle(color: AppTheme.textTertiaryColor, fontSize: 12),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'set_default') {
                  context.read<ProviderBloc>().add(
                        SetDefaultProviderEvent(providerId: provider.id),
                      );
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, provider);
                }
              },
              itemBuilder: (context) => [
                if (!provider.isDefault)
                  const PopupMenuItem(
                    value: 'set_default',
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 20),
                        SizedBox(width: 12),
                        Text('Set as Default'),
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
          ),
        );
      },
    );
  }

  IconData _getProviderIcon(ProviderType type) {
    switch (type) {
      case ProviderType.anthropic:
        return Icons.psychology;
      case ProviderType.gemini:
        return Icons.auto_awesome;
      case ProviderType.groq:
        return Icons.flash_on;
      case ProviderType.bedrock:
        return Icons.cloud;
      case ProviderType.vertex:
        return Icons.cloud_circle;
      case ProviderType.custom:
        return Icons.settings_input_component;
    }
  }

  void _showAddProviderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: const ProviderConfigForm(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProviderConfig provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Provider'),
        content: Text('Are you sure you want to delete "${provider.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProviderBloc>().add(
                    DeleteProviderEvent(providerId: provider.id),
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class ProviderConfigForm extends StatefulWidget {
  const ProviderConfigForm({super.key});

  @override
  State<ProviderConfigForm> createState() => _ProviderConfigFormState();
}

class _ProviderConfigFormState extends State<ProviderConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _modelNameController = TextEditingController();
  
  ProviderType _selectedType = ProviderType.anthropic;
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _modelNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Provider'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DropdownButtonFormField<ProviderType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Provider Type',
                border: OutlineInputBorder(),
              ),
              items: ProviderType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                  _baseUrlController.text = value.defaultBaseUrl;
                  _modelNameController.text = value.defaultModel;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'My Anthropic API',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-ant-...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an API key';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: 'Base URL (Optional)',
                hintText: _selectedType.defaultBaseUrl,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _modelNameController,
              decoration: InputDecoration(
                labelText: 'Model Name (Optional)',
                hintText: _selectedType.defaultModel,
                border: const OutlineInputBorder(),
                helperText: 'Leave empty to use default model',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Set as default provider'),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProvider,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Provider'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProvider() {
    if (_formKey.currentState!.validate()) {
      final provider = ProviderConfig(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty ? null : _baseUrlController.text,
        customModelName: _modelNameController.text.isEmpty ? null : _modelNameController.text,
        isDefault: _isDefault,
        createdAt: DateTime.now(),
      );

      context.read<ProviderBloc>().add(AddProviderEvent(provider: provider));
      Navigator.pop(context);
    }
  }
}
