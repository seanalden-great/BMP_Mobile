import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._init();
  static Database? _database;

  LocalDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bmp_erp_offline.db');
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

  Future _createDB(Database db, int version) async {
    // 1. Tabel Cache untuk menyimpan data GET (Master Produk, Gudang, Riwayat)
    await db.execute('''
      CREATE TABLE cache_data (
        cache_key TEXT PRIMARY KEY,
        json_data TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. Tabel Antrean Sinkronisasi untuk CUD (POST, PUT, DELETE) saat offline
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        method TEXT NOT NULL,
        endpoint TEXT NOT NULL,
        payload TEXT NOT NULL,
        module TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // --- OPERASI CACHE (READ OFFLINE) ---
  Future<void> saveCache(String key, String jsonData) async {
    final db = await database;
    await db.insert(
      'cache_data',
      {
        'cache_key': key,
        'json_data': jsonData,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCache(String key) async {
    final db = await database;
    final maps = await db.query(
      'cache_data',
      where: 'cache_key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['json_data'] as String;
    }
    return null;
  }

  // --- OPERASI ANTREAN SINKRONISASI (SYNC QUEUE) ---
  Future<int> addToSyncQueue({
    required String method,
    required String endpoint,
    required String payload,
    required String module,
  }) async {
    final db = await database;
    return await db.insert('sync_queue', {
      'method': method,
      'endpoint': endpoint,
      'payload': payload,
      'module': module,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List> getPendingQueue() async {
    final db = await database;
    return await db.query('sync_queue', orderBy: 'id ASC');
  }

  Future<int> getPendingCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM sync_queue');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }
}