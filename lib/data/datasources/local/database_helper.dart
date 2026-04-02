import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../core/services/app_logger.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final _logger = AppLogger();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _logger.info('Initializing database', tag: 'Database');
    _database = await _initDB('claude_code_mobile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    _logger.debug('Database path: $path', tag: 'Database');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        _logger.debug('Configuring database (enabling foreign keys)', tag: 'Database');
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    _logger.info('Creating database tables (version $version)', tag: 'Database');
    
    // Sessions table
    _logger.debug('Creating sessions table', tag: 'Database');
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        ssh_config_id TEXT NOT NULL,
        provider_id TEXT NOT NULL,
        working_directory TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Messages table
    _logger.debug('Creating messages table', tag: 'Database');
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        session_id TEXT NOT NULL,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        tool_calls TEXT,
        tool_results TEXT,
        status TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    _logger.debug('Creating database indexes', tag: 'Database');
    await db.execute('''
      CREATE INDEX idx_messages_session_id ON messages(session_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_timestamp ON messages(timestamp)
    ''');

    // SSH Configs table
    _logger.debug('Creating ssh_configs table', tag: 'Database');
    await db.execute('''
      CREATE TABLE ssh_configs (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        host TEXT NOT NULL,
        port INTEGER NOT NULL,
        username TEXT NOT NULL,
        auth_type TEXT NOT NULL,
        working_directory TEXT,
        last_connected INTEGER
      )
    ''');
    
    _logger.info('Database tables created successfully', tag: 'Database');
  }

  Future<void> close() async {
    _logger.info('Closing database', tag: 'Database');
    final db = await instance.database;
    db.close();
  }
}
