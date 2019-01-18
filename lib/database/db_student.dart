import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_flutter/model/student.dart';

class DBStudentProvider {

  static final DBStudentProvider dbStudent = new DBStudentProvider();
  Database _database ;

  Future<Database> get database async{
    if(_database != null)
      return _database ;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path , 'studentDB.db');
    return await openDatabase(path , version: 1 , onOpen: (db){} ,
      onCreate: (Database database , int version) async{
        await database.execute(''
            'CREATE TABLE student(id INTEGER PRIMARY KEY , '
            '   first_name TEXT , '
            '   last_name TEXT , '
            '   blocked BIT)');
      });
  }

  insertStudent(Student student) async{
    Database db = await database;
    var table = await db.rawQuery(''
        'SELECT MAX(id)+ 1 AS id '
        'FROM student ');
    int id = table.first['id'];
    var raw = await db.rawInsert(''
        'INSERT INTO student (id , first_name , last_name , blocked) '
        'VALUES (? , ? , ? , ?)' , [id , student.first_name , student.last_name , student.blocked]);

    return raw;

  }

  updateStudent(Student student) async {
    final db = await database ;
    var res = await db.update('student' ,student.toMap() , where: 'id = ?' , whereArgs: [student.id]);
    return res ;
  }

  getStudent (int id) async {
    final db = await database;
    var res = await db.query('student', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Student.fromMap(res.first) : null;
  }

  Future<List<Student>> getBlockedStudent () async {
    final db = await database ;
    var res = await db.query('student', where: 'blocked = ?' , whereArgs: [1]);
    List<Student> list = res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }


  Future<List<Student>> getAllStudent() async{
    final db = await database ;
    var res = await db.query('student');
    List<Student> list = res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  deleteStudent(int id) async {
    final db = await database ;
    return db.delete('student', where: 'id = ?' , whereArgs: [id]);
  }

  deleteAllStudent() async{
    final db = await database ;
    db.rawDelete('delete * from student');
  }

  blockOrUnBlock(Student student) async {
    final db = await database ;
    Student blocked = Student(
      id: student.id ,
      first_name: student.first_name,
      last_name: student.last_name,
      blocked: student.blocked ,
    );
    var res = await db.update('student', blocked.toMap(), where: 'id = ?' , whereArgs: [student.id]);
    return res;
  }
}