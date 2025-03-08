import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/database.dart';
import 'tile_list.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('todo'); // Open the Hive box
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TodoHomePage());
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final _todoBox = Hive.box('todo'); // Access the Hive box
  final TodoListDatabase db = TodoListDatabase();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialize data from Hive or create initial data if it doesn't exist
  void _initializeData() {
    if (_todoBox.get('task') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  // Toggle task completion status
  void _toggleTaskCompletion(int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  // Add a new task
  void _addTask() {
    String newTask = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            onChanged: (value) => newTask = value,
            decoration: InputDecoration(
              labelText: 'Enter New Task',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  setState(() {
                    db.todoList.add([newTask, false]); // Add new task
                  });
                  db.updateDatabase();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Add Task', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Todo App',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 242, 240, 240),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return TileList(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onchanged: (value) => _toggleTaskCompletion(index),
            onDelete: () => _deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
// class _TodoHomePageState extends State<TodoHomePage> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> tasks = []; // Task list

//   // Add Task
//   void _addTask() {
//     String text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         tasks.add({"title": text, "completed": false});
//       });
//       _controller.clear(); // Clear the input field
//     }
//   }

//   // Toggle Task Completion
//   void _toggleTask(int index) {
//     setState(() {
//       tasks[index]["completed"] = !tasks[index]["completed"];
//     });
//   }

//   // Delete Task
//   void _deleteTask(int index) {
//     setState(() {
//       tasks.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("To-Do App")),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: "Enter Tasks",
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ElevatedButton(
//                     onPressed: _addTask,
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.blue),
//                       shape: MaterialStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                             5,
//                           ), // Apply rounded corners
//                         ),
//                       ),
//                       padding: MaterialStateProperty.all(
//                         EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                       ), // Adjust padding
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.add, color: Colors.white),
//                         Text("Add", style: TextStyle(color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                     tasks[index]["title"],
//                     style: TextStyle(
//                       color: const Color.fromARGB(255, 189, 94, 17),
//                       decoration:
//                           tasks[index]["completed"]
//                               ? TextDecoration.lineThrough
//                               : null, // Strike-through if completed
//                     ),
//                   ),
//                   leading: Checkbox(
//                     value: tasks[index]["completed"],
//                     onChanged: (bool? value) {
//                       _toggleTask(index); // Toggle completion status
//                     },
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete,color: Colors.red,),
//                     onPressed: () {
//                       _deleteTask(index); // Delete task
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
