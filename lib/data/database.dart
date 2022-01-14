import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data.dart';

class DatabaseHelper {
  static const _databaseName = 'health.db';
  static const int _databaseVersion = 1;
  static const foodTable = 'food';
  static const workoutTable = 'workout';
  static const bodyTable = 'body';
  static const weightTable = 'weight';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // https://stackoverflow.com/a/67053311/7703502
  // Resolve to Database doesn't allow null
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $foodTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      image String,
      memo String,
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $workoutTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      intense INTEGER DEFAULT 0,
      part INTEGER DEFAULT 0,
      name String,
      memo String,
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $bodyTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      image String, 
      memo String,
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $weightTable (
      date INTEGER DEFAULT 0,
      weight INTEGER DEFAULT 0,
      fat INTEGER DEFAULT 0,
      muscle INTEGER DEFAULT 0,
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // foodTable
  Future<int> insertFood(Food food) async {
    Database db = await instance.database;
    final _idQuery = await db.query(foodTable, where: "id = ?", whereArgs: [food.id]);
    final _map = food.toMap();

    if (_idQuery.isEmpty) {
      return await db.insert(foodTable, _map);
    } else {
      return await db.update(foodTable, _map, where: 'id = ?', whereArgs: [food.id]);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async {
    Database db = await instance.database;
    List<Food> food = [];
    final query = await db.query(foodTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      food.add(Food.fromDB(q));
    }
    return food;
  }

  Future<List<Food>> queryAllFood() async {
    Database db = await instance.database;
    List<Food> food = [];
    final query = await db.query(foodTable);

    for (final q in query) {
      food.add(Food.fromDB(q));
    }
    return food;
  }

  // workoutTable
  Future<int> insertWorkout(Workout workout) async {
    Database db = await instance.database;
    final _idQuery = await db.query(workoutTable, where: "id = ?", whereArgs: [workout.id]);
    final _map = workout.toMap();

    if (_idQuery.isEmpty) {
      return await db.insert(workoutTable, _map);
    } else {
      return await db.update(workoutTable, _map, where: 'id = ?', whereArgs: [workout.id]);
    }
  }

  Future<List<Workout>> queryWorkoutByDate(int date) async {
    Database db = await instance.database;
    List<Workout> workout = [];
    final query = await db.query(workoutTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      workout.add(Workout.fromDB(q));
    }
    return workout;
  }

  Future<List<Workout>> queryAllWorkout() async {
    Database db = await instance.database;
    List<Workout> workout = [];
    final query = await db.query(workoutTable);

    for (final q in query) {
      workout.add(Workout.fromDB(q));
    }
    return workout;
  }

  // bodyTable
  Future<int> insertEyeBody(EyeBody body) async {
    Database db = await instance.database;
    final _idQuery = await db.query(bodyTable, where: "id = ?", whereArgs: [body.id]);
    final _map = body.toMap();

    if (_idQuery.isEmpty) {
      return await db.insert(bodyTable, _map);
    } else {
      return await db.update(bodyTable, _map, where: 'id = ?', whereArgs: [body.id]);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async {
    Database db = await instance.database;
    List<EyeBody> body = [];
    final query = await db.query(bodyTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      body.add(EyeBody.fromDB(q));
    }
    return body;
  }

  Future<List<EyeBody>> queryAllEyeBody() async {
    Database db = await instance.database;
    List<EyeBody> body = [];
    final query = await db.query(bodyTable);

    for (final q in query) {
      body.add(EyeBody.fromDB(q));
    }
    return body;
  }

  // weightTable
  Future<int> insertWeight(Weight weight) async {
    Database db = await instance.database;
    List<Weight> _d = await queryWeightByDate(weight.date);
    final _map = weight.toMap();

    if (_d.isEmpty) {
      return await db.insert(weightTable, _map);
    } else {
      return await db.update(weightTable, _map, where: 'date = ?', whereArgs: [weight.date]);
    }
  }

  Future<List<Weight>> queryWeightByDate(int date) async {
    Database db = await instance.database;
    List<Weight> weight = [];
    final query = await db.query(weightTable, where: 'date = ?', whereArgs: [date]);

    for (final q in query) {
      weight.add(Weight.fromDB(q));
    }
    return weight;
  }

  Future<List<Weight>> queryAllWeight() async {
    Database db = await instance.database;
    List<Weight> weight = [];
    final query = await db.query(weightTable);

    for (final q in query) {
      weight.add(Weight.fromDB(q));
    }
    return weight;
  }
}
