import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/task_model.dart';

class DbHelper
{
  static Database? database;

  Future<Database?> createDatabase() async
  {
    if(database != null)
    {
      return database;
    }else
    {
      String path = join(await getDatabasesPath() , 'roadmap.db');
      Database myDatabase = await openDatabase(
          path,
          version: 1,
          onCreate: (db , v)
          {
            db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT)');
          }
      );
      return myDatabase;
    }
  }

  Future<List> readFromDatabase() async
  {
    Database? myDatabase = await createDatabase();
    return myDatabase!.query('tasks');
  }

  Future<int> insertToDatabase(TaskModel taskModel) async
  {
    Database? myDatabase = await createDatabase();
    return myDatabase!.insert('tasks', taskModel.toMap());
  }

  Future<int> deleteFromDatabase(int id) async
  {
    Database? myDatabase = await createDatabase();
    return myDatabase!.delete('tasks' , where: 'id = ?' , whereArgs: [id]);
  }
}