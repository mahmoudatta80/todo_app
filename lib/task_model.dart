class TaskModel
{
  int? id;
  String? title;
  String? time;
  String? date;

  TaskModel(dynamic obJ)
  {
    id = obJ['id'];
    title = obJ['title'];
    time = obJ['time'];
    date = obJ['date'];
  }

  TaskModel.fromMap(Map<String , dynamic> map)
  {
    id = map['id'];
    title = map['title'];
    time = map['time'];
    date = map['date'];
  }

  Map<String , dynamic> toMap() =>{'id':id , 'title':title , 'time':time , 'date':date};
}