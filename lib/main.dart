import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  DateTime? _selectedDate;

  int? _editIndex;

  void _addOrUpdateTask() {
    final taskText = _taskController.text.trim();
    if (taskText.isEmpty || _selectedDate == null) return;

    setState(() {
      if (_editIndex == null) {
        // Add mode
        _tasks.add({
          'title': taskText,
          'completed': false,
          'date': _selectedDate,
        });
      } else {
        // Update mode
        _tasks[_editIndex!] = {
          'title': taskText,
          'completed': false,
          'date': _selectedDate,
        };
        _editIndex = null;
      }

      _taskController.clear();
      _selectedDate = null;
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    setState(() {
      _taskController.text = _tasks[index]['title'];
      _selectedDate = _tasks[index]['date'];
      _editIndex = index;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = _tasks.where((t) => t['completed']).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('To-Do App'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "$completedTasks of ${_tasks.length} tasks completed",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.blue),
                  onPressed: _pickDate,
                ),
                IconButton(
                  icon: Icon(
                    _editIndex == null ? Icons.add_circle : Icons.update,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: _addOrUpdateTask,
                ),
              ],
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.event, size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: Checkbox(
                        value: task['completed'],
                        onChanged: (_) => _toggleTaskCompletion(index),
                      ),
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['completed'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "${task['date'].day}/${task['date'].month}/${task['date'].year}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () => _editTask(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
