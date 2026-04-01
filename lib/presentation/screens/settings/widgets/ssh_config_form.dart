import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claude_code_mobile/core/theme/app_theme.dart';
import 'package:claude_code_mobile/domain/entities/ssh_config.dart';
import 'package:claude_code_mobile/presentation/blocs/connection/connection_bloc.dart' as connection;

class SSHConfigForm extends StatefulWidget {
  const SSHConfigForm({super.key});

  @override
  State<SSHConfigForm> createState() => _SSHConfigFormState();
}

class _SSHConfigFormState extends State<SSHConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '22');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _workingDirController = TextEditingController(text: '/home');
  
  SSHAuthType _authType = SSHAuthType.password;
  bool _verifyHostKey = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _workingDirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SSH Connection',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              
              // Connection Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Connection Name',
                  hintText: 'My Server',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a connection name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Host
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Host',
                  hintText: '192.168.1.100 or example.com',
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a host';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Port
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '22',
                  prefixIcon: Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a port';
                  }
                  final port = int.tryParse(value);
                  if (port == null || port < 1 || port > 65535) {
                    return 'Please enter a valid port (1-65535)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'root',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Auth Type
              DropdownButtonFormField<SSHAuthType>(
                value: _authType,
                decoration: const InputDecoration(
                  labelText: 'Authentication Type',
                  prefixIcon: Icon(Icons.security),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SSHAuthType.password,
                    child: Text('Password'),
                  ),
                  DropdownMenuItem(
                    value: SSHAuthType.privateKey,
                    child: Text('Private Key (Not implemented yet)'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _authType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Password (only if password auth)
              if (_authType == SSHAuthType.password)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (_authType == SSHAuthType.password && 
                        (value == null || value.isEmpty)) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              
              // Working Directory
              TextFormField(
                controller: _workingDirController,
                decoration: const InputDecoration(
                  labelText: 'Working Directory',
                  hintText: '/home/user/project',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
              ),
              const SizedBox(height: 16),
              
              // Verify Host Key
              SwitchListTile(
                title: const Text('Verify Host Key'),
                subtitle: const Text('Recommended for security'),
                value: _verifyHostKey,
                onChanged: (value) {
                  setState(() {
                    _verifyHostKey = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _connect,
                    child: const Text('Connect'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _connect() {
    if (_formKey.currentState!.validate()) {
      final config = SSHConfig(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        host: _hostController.text,
        port: int.parse(_portController.text),
        username: _usernameController.text,
        authType: _authType,
        password: _authType == SSHAuthType.password ? _passwordController.text : null,
        verifyHostKey: _verifyHostKey,
        workingDirectory: _workingDirController.text.isEmpty 
            ? null 
            : _workingDirController.text,
      );

      context.read<connection.ConnectionBloc>().add(
            connection.ConnectToServerEvent(config),
          );

      Navigator.pop(context);
      
      // Show connecting snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to ${config.name}...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
