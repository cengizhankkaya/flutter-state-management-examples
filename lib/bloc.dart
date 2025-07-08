import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. Sayaç Bloc
// --- Event ---
abstract class CounterEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

// --- Bloc ---
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}

// 2. Tema Bloc
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, bool> {
  ThemeBloc() : super(false) {
    on<ToggleTheme>((event, emit) => emit(!state));
  }
}

// 3. Todo Bloc
abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class ToggleTodo extends TodoEvent {
  final int index;
  ToggleTodo(this.index);
}

class RemoveTodo extends TodoEvent {
  final int index;
  RemoveTodo(this.index);
}

class Todo {
  final String title;
  final bool completed;
  Todo(this.title, {this.completed = false});
  Todo copyWith({String? title, bool? completed}) =>
      Todo(title ?? this.title, completed: completed ?? this.completed);
}

class TodoBloc extends Bloc<TodoEvent, List<Todo>> {
  TodoBloc() : super([]) {
    on<AddTodo>((event, emit) => emit([...state, Todo(event.title)]));
    on<ToggleTodo>((event, emit) {
      emit([
        for (int i = 0; i < state.length; i++)
          if (i == event.index)
            state[i].copyWith(completed: !state[i].completed)
          else
            state[i],
      ]);
    });
    on<RemoveTodo>((event, emit) {
      emit([
        for (int i = 0; i < state.length; i++)
          if (i != event.index) state[i],
      ]);
    });
  }
}

class BlocExamplesPage extends StatelessWidget {
  const BlocExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => TodoBloc()),
      ],
      child: const BlocExamplesView(),
    );
  }
}

class BlocExamplesView extends StatelessWidget {
  const BlocExamplesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Örnekleri'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCounterExample(context),
            const SizedBox(height: 20),
            _buildThemeExample(context),
            const SizedBox(height: 20),
            _buildTodoExample(context),
          ],
        ),
      ),
      backgroundColor: theme ? Colors.grey[900] : Colors.white,
    );
  }

  Widget _buildCounterExample(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Sayaç (Bloc)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Bloc ile sayaç yönetimi',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CounterBloc, int>(
              builder: (context, count) => Text(
                'Sayaç: $count',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.read<CounterBloc>().add(Decrement()),
                  child: const Text('Azalt'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => context.read<CounterBloc>().add(Increment()),
                  child: const Text('Artır'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeExample(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Tema (Bloc)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Bloc ile tema (açık/koyu) değiştirme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ThemeBloc, bool>(
              builder: (context, isDark) => Text(
                'Tema: ${isDark ? "Koyu" : "Açık"}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
              child: const Text('Temayı Değiştir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoExample(BuildContext context) {
    final controller = TextEditingController();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. Todo List (Bloc)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Bloc ile yapılacaklar listesi yönetimi',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Yeni görev ekle',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      context.read<TodoBloc>().add(
                        AddTodo(controller.text.trim()),
                      );
                      controller.clear();
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            BlocBuilder<TodoBloc, List<Todo>>(
              builder: (context, todos) => Column(
                children: todos.asMap().entries.map((entry) {
                  final i = entry.key;
                  final todo = entry.value;
                  return ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) =>
                          context.read<TodoBloc>().add(ToggleTodo(i)),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          context.read<TodoBloc>().add(RemoveTodo(i)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
