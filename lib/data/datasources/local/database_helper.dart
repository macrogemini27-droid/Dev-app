import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('claude_code_mobile.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Sessions table
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
    await db.execute('''
      CREATE INDEX idx_messages_session_id ON messages(session_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_timestamp ON messages(timestamp)
    ''');

    // SSH Configs table
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
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
