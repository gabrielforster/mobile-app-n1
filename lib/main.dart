import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do List',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xFF038BBB),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF03223F),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF03223F),
            side: BorderSide(color: Colors.white),
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFFFCCB6F);
            }
            return Color(0xFF010D23);
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF03223F),
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];
  String _filtro = 'Todas';

  void _adicionarTodo() {
    if (_todoController.text.isNotEmpty) {
      setState(() {
        _todos.add({'title': _todoController.text, 'status': 'em progresso'});
        _todoController.clear();
      });
    }
  }

  void _editarTodoTitle(int index, String newTitle) {
    setState(() {
      _todos[index]['title'] = newTitle;
    });
  }

  void _mudarStatus(int index, String newStatus) {
    setState(() {
      _todos[index]['status'] = newStatus;
    });
  }

  void _removerTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _setFiltro(String filtro) {
    setState(() {
      _filtro = filtro;
    });
  }

  List<Map<String, dynamic>> _filtrarTodos() {
    if (_filtro == 'Todas') {
      return _todos;
    } else {
      return _todos.where((todo) => todo['status'] == _filtro.toLowerCase()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do list'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFF010D23),
                    title: Text('Adicionar Tarefa', style: TextStyle(color: Colors.white)),
                    content: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        labelText: 'Título da tarefa',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _adicionarTodo();
                          Navigator.of(context).pop();
                        },
                        child: Text('Adicionar', style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          _todoController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Nova tarefa',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _adicionarTodo,
            child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _setFiltro('Todas'),
                child: const Text('Todas', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => _setFiltro('concluída'),
                child: const Text('Finalizadas', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => _setFiltro('em progresso'),
                child: const Text('Em Progresso', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filtrarTodos().length,
              itemBuilder: (context, index) {
                final todo = _filtrarTodos()[index];
                return Card(
                  color: Color(0xFF03223F),
                  child: ListTile(
                    title: Text(todo['title'], style: TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo['status'] == 'concluída',
                          onChanged: (value) {
                            _mudarStatus(index, value! ? 'concluída' : 'em progresso');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final _editController = TextEditingController(text: todo['title']);
                                return AlertDialog(
                                  backgroundColor: Color(0xFF010D23),
                                  title: Text('Editar Tarefa', style: TextStyle(color: Colors.white)),
                                  content: TextField(
                                    controller: _editController,
                                    decoration: const InputDecoration(
                                      labelText: 'Título da tarefa',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _editarTodoTitle(index, _editController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Salvar', style: TextStyle(color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _removerTodo(index),
                        ),
                      ],
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
