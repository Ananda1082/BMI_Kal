import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bmi_kalkulator.db');
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
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Tabel untuk BMI History
    await db.execute('''
CREATE TABLE bmi_history (
  id $idType,
  berat $realType,
  tinggi $realType,
  bmi $realType,
  kategori $textType,
  jenisKelamin $textType,
  waktu $integerType
)
''');

    // Tabel untuk Goals
    await db.execute('''
CREATE TABLE goals (
  id $idType,
  nama $textType,
  beratSekarang $realType,
  targetBerat $realType,
  tenggat $integerType,
  dibuat $integerType
)
''');
  }

  // ========== BMI History Methods ==========

  Future<void> insertBmiHistory(Map<String, dynamic> bmiData) async {
    final db = await database;
    await db.insert(
      'bmi_history',
      bmiData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllBmiHistory() async {
    final db = await database;
    return await db.query(
      'bmi_history',
      orderBy: 'waktu DESC',
    );
  }

  Future<void> deleteBmiHistory(String id) async {
    final db = await database;
    await db.delete(
      'bmi_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllBmiHistory() async {
    final db = await database;
    await db.delete('bmi_history');
  }

  // ========== Goals Methods ==========

  Future<void> insertGoal(Map<String, dynamic> goalData) async {
    final db = await database;
    await db.insert(
      'goals',
      goalData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllGoals() async {
    final db = await database;
    return await db.query(
      'goals',
      orderBy: 'dibuat DESC',
    );
  }

  Future<void> deleteGoal(String id) async {
    final db = await database;
    await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllGoals() async {
    final db = await database;
    await db.delete('goals');
  }

  // ========== Close Database ==========

  Future close() async {
    final db = await database;
    db.close();
  }
}
