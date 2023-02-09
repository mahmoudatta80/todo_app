import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db_helper.dart';
import 'package:todo_app/task_model.dart';
class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DbHelper? helper;
  @override
  void initState() {
    super.initState();
    helper= DbHelper();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          'Tasker',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            //width: double.infinity,
            //height: 80,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children:
                [
                  Row(
                    children:
                    [
                      Text(
                        DateTime.now().day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          Text(
                            DateFormat('MMMM').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateTime.now().year.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    DateFormat('EEEE').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.indigoAccent,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 14,
                end: 14,
              ),
              child: FutureBuilder(
                future: helper!.readFromDatabase(),
                builder: (context, AsyncSnapshot? snapshot) {
                  if(!snapshot!.hasData)
                  {
                    return CircularProgressIndicator();
                  }else
                  {
                    return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context , index) => Container(
                        padding: EdgeInsetsDirectional.all(10,),
                        margin: EdgeInsetsDirectional.only(
                          top: 10,
                          bottom: 10,
                        ),
                        height: 100,
                        child: Row(
                          children:
                          [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                [
                                  Text(
                                    '${snapshot.data[index]['title']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${snapshot.data[index]['date']}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '${snapshot.data[index]['time']}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: ()
                              {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        'Delete'
                                    ),
                                    content: Text(
                                        'Are you sure , you wanna delete this task'
                                    ),
                                    actions:
                                    [
                                      TextButton(
                                        onPressed: ()
                                        {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors.indigoAccent,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: ()
                                        {
                                          setState(() {
                                            helper!.deleteFromDatabase(snapshot.data[index]['id']);
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.indigoAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(20,),
                        ),
                      ),
                      separatorBuilder: (context , index) => Container(
                        height: .5,
                        padding: EdgeInsetsDirectional.only(
                          start: 10,
                          end: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                      itemCount: snapshot.data.length,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if(isBottomSheetShown)
          {
            if(formKey.currentState!.validate())
            {
              TaskModel taskModel = TaskModel({'title':titleController.text , 'time':timeController.text , 'date':dateController.text});
              helper!.insertToDatabase(taskModel);
              Navigator.of(context).pop();
            }else
            {
              return null;
            }
            setState(() {
              isBottomSheetShown = false;
            });
          }else
          {
            titleController.text = '';
            timeController.text = '';
            dateController.text = '';
            scaffoldKey.currentState!.showBottomSheet(
                  (context) => Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                        [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                            label: Text(
                              'Task Title',
                            ),
                              prefixIcon: Icon(
                                Icons.title,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15,),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'It must not be empty';
                              }else
                              {
                                return null;
                              }
                              },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: timeController,
                            decoration: InputDecoration(
                              label: Text(
                                'Task Time',
                              ),
                              prefixIcon: Icon(
                                Icons.watch_later_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15,),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if(value!.isEmpty)
                              {
                                return 'It must not be empty';
                              }else
                              {
                                return null;
                              }
                              },
                            onTap: ()
                            {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value)
                              {
                                timeController.text = value!.format(context).toString();
                              });
                              },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              controller: dateController,
                              decoration: InputDecoration(
                                label: Text(
                                  'Task Date',
                                ),
                                prefixIcon: Icon(
                                  Icons.calendar_month_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15,),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if(value!.isEmpty)
                                {
                                  return 'It must not be empty';
                                }else
                                {
                                  return null;
                                }
                                },
                              onTap: ()
                              {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2028-11-10'),
                                ).then((value)
                                {
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              }
                              ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            child: MaterialButton(
                              onPressed: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  TaskModel taskModel = TaskModel({'title':titleController.text , 'time':timeController.text , 'date':dateController.text});
                                  helper!.insertToDatabase(taskModel);
                                  Navigator.of(context).pop();
                                }else
                                {
                                  return null;
                                }
                                },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15,),
                              color: Colors.indigoAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ).closed.then((value)
            {
              setState(() {
                isBottomSheetShown = false;
              });
            });
            setState(() {
              isBottomSheetShown = true;
            });
          }
          },
        child: Icon(
          isBottomSheetShown? Icons.edit : Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}