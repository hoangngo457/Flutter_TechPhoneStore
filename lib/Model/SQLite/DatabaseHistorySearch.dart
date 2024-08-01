import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('search_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE search_history ( 
      id $idType, 
      query $textType
    )
    ''');
  }

  Future<int?> insertSearchHistory(String query) async {
  if (query.isEmpty||query=='') {
    print('Không có giá trị, không cần lưu');
    return null;
  } else {
    final db = await instance.database;
    final data = {'query': query};
    final id = await db.insert('search_history', data);
    return id;
  }
}


  Future<List<SearchItem>> fetchSearchHistory() async {
    final db = await instance.database;

    final result = await db.query('search_history');

    return result
        .map((json) => SearchItem(
              id: json['id'] as int,
              query: json['query'] as String,
            ))
        .toList();
  }

  Future<int> clearSearchHistory() async {
    final db = await instance.database;

    return await db.delete('search_history');
  }

  Future<int> removeSearchHistory(int id) async {
    final db = await instance.database;

    return await db.delete('search_history', where: 'id = ?', whereArgs: [id]);
  }
}

class SearchItem {
  final int id;
  final String query;

  SearchItem({required this.id, required this.query});
}
