import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  List<Todo> _todos = [];
  bool _filtrarFinalizadas = false;

  void _adicionarTodo() {
    if (_todoController.text.isNotEmpty) {
      setState(() {
        _todos.add(Todo(_todoController.text, false));
        _todoController.clear();
      });
    }
  }

  void _filtrarTarefas() {
    setState(() {
      _filtrarFinalizadas = !_filtrarFinalizadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Nova tarefa',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _adicionarTodo,
            child: const Text('Adicionar'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filtrarFinalizadas = false;
                  });
                },
                child: const Text('Todas'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filtrarFinalizadas = true;
                  });
                },
                child: const Text('Finalizadas'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filtrarFinalizadas = false;
                  });
                },
                child: const Text('Não finalizadas'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                if (_filtrarFinalizadas == null) {
                  return ListTile(
                    title: Text(_todos[index].titulo),
                    trailing: Checkbox(
                      value: _todos[index].finalizada,
                      onChanged: (value) {
                        setState(() {
                          _todos[index].finalizada = value!;
                        });
                      },
                    ),
                  );
                } else if (_filtrarFinalizadas) {
                  if (_todos[index].finalizada) {
                    return ListTile(
                      title: Text(_todos[index].titulo),
                      trailing: Checkbox(
                        value: _todos[index].finalizada,
                        onChanged: (value) {
                          setState(() {
                            _todos[index].finalizada = value!;
                          });
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  if (!_todos[index].finalizada) {
                    return ListTile(
                      title: Text(_todos[index].titulo),
                      trailing: Checkbox(
                        value: _todos[index].finalizada,
                        onChanged: (value) {
                          setState(() {
                            _todos[index].finalizada = value!;
                          });
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String titulo;
  bool finalizada;

  Todo(this.titulo, this.finalizada);
}
