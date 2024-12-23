import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/screen/task_creation_screen.dart';

import '../services/task_model_db.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({super.key});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from database
  Future<void> _loadTasks() async {
    final loadedTasks = await TaskDatabaseHelper.instance.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  // Toggle task completion status
  void _toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await TaskDatabaseHelper.instance.updateTask(task);
    _loadTasks();
  }

  // Delete task
  void _deleteTask(int taskId) async {
    await TaskDatabaseHelper.instance.deleteTask(taskId);
    _loadTasks();
  }

  String formatTime(String dueDate) {
    DateTime parsedDate = DateTime.parse(dueDate); // Parse the string to DateTime
    return DateFormat('hh:mm a').format(parsedDate); // Format to 'hh:mm AM/PM'
  }
  // Function to extract and format only the time from the dueDate string
  String _getTimeFromDueDate(String dueDate) {
    final dateTime = DateTime.parse(dueDate); // Parse the date string
    final formattedTime =
        DateFormat('hh:mm a').format(dateTime); // Format the time (AM/PM)
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing:
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${formatTime(task.dueDate)}"),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskCreationScreen(task: task,)));
                    }, icon: Icon(Icons.edit,color: Colors.blue))
                  ],
                ), // Display only time
            leading: IconButton(
              icon: Icon(task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () => _toggleTaskCompletion(task),
            ),
            onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Are you sure to Delete?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        _deleteTask(task.id!);
                        Navigator.pop(context);
                      },
                      child: const Text("DELETE"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
