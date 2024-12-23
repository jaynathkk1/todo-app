import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_list_app/screen/home_screen.dart';
import '../services/task_model_db.dart';

class TaskCreationScreen extends StatefulWidget {
  final Task? task;
  const TaskCreationScreen({super.key, this.task});

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _priority = 'Low';
  String _dueDate = '2024-12-31 12:00 PM';  // Include time in the initial date
  // Initialize the task fields if editing
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  // Save or update the task to database
  void _saveTask() async {
    final task = Task(
      id: widget.task?.id,  // Keep the existing ID if editing
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task?.isCompleted ?? false,
      priority: _priority,
      dueDate: _dueDate.toString(),
    );

    if (task.id == null) {
      // If task is new, add the task
      await TaskDatabaseHelper.instance.addTask(task);
    } else {
      // If task has an ID, update the task
      await TaskDatabaseHelper.instance.updateTask(task);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text(widget.task!=null?"Updated Task Successfully..":"Added Task Successfully.."),));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
  }


  // Function to pick a date
  Future<void> _pickDueDate(BuildContext context) async {
    final initialDate = DateTime.parse(_dueDate.split(' ')[0]);  // Extract date part
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020), // You can set the minimum date
      lastDate: DateTime(2101),  // You can set the maximum date
    );
    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _dueDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} ${_dueDate.split(' ')[1]}';
      });
    }
  }

  // Function to pick a time (with AM/PM)
  Future<void> _pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.fromDateTime(DateTime.parse(_dueDate));  // Extract time part
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null && pickedTime != initialTime) {
      print(pickedTime.hour);
      print(pickedTime.minute);
      final formattedTime = pickedTime.format(context);  // Get time in AM/PM format
      setState(() {
        // Combine the date and time
        _dueDate = '${_dueDate.split(' ')[0]} $formattedTime';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<String>(
              value: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
              items: ['Low', 'Medium', 'High']
                  .map((priority) => DropdownMenuItem(
                value: priority,
                child: Text(priority),
              ))
                  .toList(),
            ),
            GestureDetector(
              onTap: () => _pickDueDate(context), // Open date picker on tap
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: _dueDate.split(' ')[0]),  // Display only the date part initially
                  decoration: const InputDecoration(labelText: 'Due Date'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _pickTime(context),  // Open time picker on tap
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: _dueDate.split(' ')[1]),  // Display only the time part initially
                  decoration: const InputDecoration(labelText: 'Due Time (AM/PM)'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child:  Text(widget.task == null ? 'Save Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
