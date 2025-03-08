import 'package:flutter/material.dart';

class TileList extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;

  Function(bool?)? onchanged;
  VoidCallback? onDelete;

  TileList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onchanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(218, 212, 230, 245),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              activeColor: Colors.black,
              onChanged: onchanged,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                taskName,

                style: TextStyle(
                  decoration:
                      taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  decorationColor:
                      taskCompleted
                          ? Colors.red
                          : Colors.transparent, // Line color
                  decorationThickness:
                      taskCompleted ? 2.0 : 0.0, // Thickness of the line
                  color:
                      taskCompleted
                          ? Colors.red
                          : Colors.black, // Text color when completed
                  fontSize: 20,
                  fontWeight:
                      taskCompleted
                          ? FontWeight.bold
                          : FontWeight.normal, // Bold text when completed
                ),
              ),
            ),
            InkWell(
              onTap: onDelete, // Trigger the delete action
              child: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
