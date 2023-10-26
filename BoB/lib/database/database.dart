import 'dart:async';
import 'package:intl/intl.dart';

import '../database/diaryDB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'diary.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE diary(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, title TEXT NOT NULL, content TEXT NOT NULL, image TEXT)');
  }

  Future<int> add(Diary diary) async {
    Database db = await instance.database;
    var response = await db.insert('diary', diary.toMap());
    return response;
  }

  Future<Diary> getDiary(DateTime date) async {
    Database db = await instance.database;
    String selDate = DateFormat('yyyy.MM.dd').format(date);
    List<Map<String, dynamic>> diaries = await db.query('diary', where: '"date" = ?', whereArgs: [selDate]);
    return Diary.fromMap(diaries[0]);
  }

  Future<bool> isDiary(DateTime date) async {
    Database db = await instance.database;
    String selDate = DateFormat('yyyy.MM.dd').format(date);
    List<Map<String, dynamic>> diaries = await db.query('diary', where: '"date" = ?', whereArgs: [selDate]);
    return diaries[0].isEmpty;
  }

  Future<int> update(Diary diary) async {
    Database db = await instance.database;
    return await db.update('diary', diary.toMap(),
        where: 'date = ?', whereArgs: [diary.date]);
  }

  Future<int> remove(DateTime date) async {
    Database db = await instance.database;
    return await db.delete('diary', where: 'date = ?', whereArgs: [DateFormat('yyyy.MM.dd').format(date)]);
  }

}