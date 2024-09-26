import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do List',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: HexColor.fromHex('#fccb6f'),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF03223F),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF03223F),
            side: const BorderSide(color: Colors.white),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFFCCB6F);
            }
            return const Color(0xFF010D23);
          }),
        ),
        inputDecorationTheme: const InputDecorationTheme(
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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoController = TextEditingController();
  final List<Map<String, dynamic>> _todos = [];
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
      return _todos
          .where((todo) => todo['status'] == _filtro.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do list'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF010D23),
                    title: const Text('Adicionar Tarefa',
                        style: TextStyle(color: Colors.white)),
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
                        child: const Text('Adicionar',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          _todoController.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.white)),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _setFiltro('Todas'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: _filtro == 'Todas'
                      ? const Color(0xFF03223F)
                      : Colors.white,
                  backgroundColor: _filtro == 'Todas'
                      ? Colors.white
                      : const Color(0xFF03223F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text('Todas'),
              ),
              ElevatedButton(
                onPressed: () => _setFiltro('concluída'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: _filtro == 'concluída'
                      ? const Color(0xFF03223F)
                      : Colors.white,
                  backgroundColor: _filtro == 'concluída'
                      ? Colors.white
                      : const Color(0xFF03223F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text('Finalizadas'),
              ),
              ElevatedButton(
                onPressed: () => _setFiltro('em progresso'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: _filtro == 'em progresso'
                      ? const Color(0xFF03223F)
                      : Colors.white,
                  backgroundColor: _filtro == 'em progresso'
                      ? Colors.white
                      : const Color(0xFF03223F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text('Em Progresso'),
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
                  color: const Color(0xFF03223F),
                  child: ListTile(
                    title: Text(todo['title'],
                        style: const TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo['status'] == 'concluída',
                          onChanged: (value) {
                            _mudarStatus(
                                index, value! ? 'concluída' : 'em progresso');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final editController =
                                    TextEditingController(text: todo['title']);
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF010D23),
                                  title: const Text('Editar Tarefa',
                                      style: TextStyle(color: Colors.white)),
                                  content: TextField(
                                    controller: editController,
                                    decoration: const InputDecoration(
                                      labelText: 'Título da tarefa',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _editarTodoTitle(
                                            index, editController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Salvar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancelar',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
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
