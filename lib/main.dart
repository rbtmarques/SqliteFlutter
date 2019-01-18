import 'package:flutter/material.dart';
import 'package:sqlite_flutter/model/student.dart';
import 'package:sqlite_flutter/database/db_student.dart';
import 'dart:math' as math;

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{

  List<Student> testStudent = [
    Student(first_name: 'Phong' , last_name: 'Nguyen' , blocked: false),
    Student(first_name: 'Anh' , last_name: 'Do', blocked: true),
    Student(first_name: 'Thanh', last_name: 'Le' , blocked: false),
  ];


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('SQLITE IN FLUTTER'),

      ),
      body: new FutureBuilder(
          future: DBStudentProvider.dbStudent.getAllStudent(),
          builder: (BuildContext context , AsyncSnapshot<List<Student>> snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context , int index){
                    Student student = snapshot.data[index];
                    return Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Colors.red,),
                        onDismissed: (direction){
                          DBStudentProvider.dbStudent.deleteStudent(student.id);
                        },
                        child: new ListTile(
                          title: new Text(student.last_name),
                          leading: new Text(student.id.toString()),
                          trailing: Checkbox(
                              value: student.blocked,
                              onChanged: (bool check){
                                DBStudentProvider.dbStudent.blockOrUnBlock(student);
                                setState(() {

                                });
                              }),
                        ),
                    );
                  }
              );
            }else {
              return new Center(child: new CircularProgressIndicator(),);
            }
          }
      ),

      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () async {
            Student student = testStudent[math.Random().nextInt(testStudent.length)];
            await DBStudentProvider.dbStudent.insertStudent(student);
            setState(() {

            });
          }
      ),
    );
  }
}

void main(){
  runApp(new MaterialApp(home: MyApp(),));
}