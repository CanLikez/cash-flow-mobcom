import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? factory, String? path})
      : _factory = factory ?? databaseFactory,
        _databasePath = path;

  static final AppDatabase instance = AppDatabase();

  static const String _fileName = 'cash_flow.db';
  static const String table = 'transactions';

  final DatabaseFactory _factory;
  final String? _databasePath;
  Future<Database>? _database;

  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    final path =
        _databasePath ?? p.join(await _factory.getDatabasesPath(), _fileName);

    return _factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
CREATE TABLE $table (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  type TEXT NOT NULL,
  date INTEGER NOT NULL,
  category TEXT,
  note TEXT
)
''');
        },
      ),
    );
  }

  Future<void> close() async {
    final database = _database;
    _database = null;
    if (database == null) return;

    try {
      final db = await database;
      await db.close();
    } catch (_) {
      // Opening failed; nothing to close.
    }
  }
}
