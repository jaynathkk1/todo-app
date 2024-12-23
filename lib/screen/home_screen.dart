import 'package:flutter/material.dart';
import 'package:todo_list_app/screen/task_creation_screen.dart';
import 'package:todo_list_app/widget/task_tile.dart';

import '../services/task_model_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  String name = "Jay";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Text('Menu Button')
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.grey,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Hello $name",
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "${tasks.length} Task are Pending",
              style: const TextStyle(fontSize: 16,color: Colors.grey),
            ),
            const SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search,color: Colors.grey,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 0.1)
                ),
                hintText: 'Search Course',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: const Icon(Icons.filter_list_rounded,color: Colors.redAccent,),
              ),
            ),
            const SizedBox(height: 20,),
            const Text("Ongoing Task",style: TextStyle(color: Colors.grey),),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                       Container(
                         width: 30,
                         height: 30,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(50),
                           color: Colors.grey,
                         ),
                         child: Center(
                           child: Container(
                             width: 25,
                             height: 25,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(50),
                               color: Colors.white,
                             ),
                           ),
                         ),
                       ),
                        const Spacer(),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text('6 Days Left',style: TextStyle(color: Colors.redAccent),),
                        )
                      ],
                    ),
                    Row(children: [
                      const Column(
                        children: [
                          Text('Space App Design',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Team member',style: TextStyle(color: Colors.grey)),
                          SizedBox(
                            width: 200,
                            height: 60,
                            child: Stack(
                              children: [
                              Positioned(
                                left: 10,
                                  bottom: 10,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.redAccent,)),
                              Positioned(
                                left: 20,
                                  bottom: 10,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,)),
                              Positioned(
                                left: 30,
                                  bottom: 10,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.green,)),
                                Positioned(
                                    left:45,
                                    bottom: 10,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 15,
                                        child: Icon(Icons.add,color: Colors.grey,)))
                            ],),
                          ),
                          SizedBox(height: 10,),
                          Row(children: [
                            Icon(Icons.watch_later_outlined,color: Colors.redAccent,),
                            SizedBox(width: 10,),
                            Text("10:30 am to 01:30")
                          ],)
                        ],
                      ),
                      const Spacer(),
                      Image.asset("assets/Space.png",fit: BoxFit.cover,width: 100,height: 120,)
                    ],)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const Row(children: [
              Text("Today\'s Task ",style: TextStyle(color: Colors.grey),),
              Spacer(),
              Text("See All",style: TextStyle(color: Colors.redAccent),),
            ],),
            const SizedBox(height: 10,),
            const Expanded(child: TaskTile()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) =>   TaskCreationScreen()));
          _loadTasks();
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(30)),
          child: const Center(
              child: Text(
            "Add New task",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
        ),
      ),
    );
  }
}
