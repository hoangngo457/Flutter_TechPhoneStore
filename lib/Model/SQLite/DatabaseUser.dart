import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Users.db');
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
    CREATE TABLE user_login ( 
      id $idType, 
      roleId $textType,
      fullName $textType,
      phoneNumber $textType,
      email $textType,
      address $textType,
      image TEXT
    )
    ''');
  }

  Future<int?> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    final id = await db.insert('user_login', user);
    return id;
  }

  Future<List<Map<String, dynamic>>> fetchUserLogin() async {
    final db = await instance.database;
    final result = await db.query('user_login');
    return result;
  }

  Future<int> clearUserLogin() async {
    final db = await instance.database;
    return await db.delete('user_login');
  }
}
