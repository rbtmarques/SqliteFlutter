import 'dart:convert';

class Student {
  int id ;
  String first_name ;
  String last_name ;
  bool blocked ;

  Student({this.id , this.first_name , this.last_name , this.blocked});

  factory Student.fromMap(Map<String , dynamic> json){
    return new Student(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      blocked: json['blocked'] == 1,
    );
  }

  Map<String , dynamic> toMap()=>{
    'id': id ,
    'first_name': first_name,
    'last_name': last_name,
    'blocked': blocked,
  };

}

Student studentFromJson(String str){
  final jsonData = json.decode(str);
  return Student.fromMap(jsonData);
}

String studentToJson (Student student){
  final dyn = student.toMap();
  return json.encode(dyn);
}