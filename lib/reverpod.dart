import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 1. Sayaç Provider'ı
final counterProvider = StateProvider<int>((ref) => 0);

/// 2. Kullanıcı adı Provider'ı
final userNameProvider = StateProvider<String>((ref) => 'Kullanıcı');

/// 3. Tema Provider'ı (açık/koyu)
final themeProvider = StateProvider<bool>((ref) => false);

/// 3. Asenkron veri çekme örneği (FutureProvider)
final timeProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return DateTime.now().toString();
});

/// 4. Todo List (StateNotifierProvider)
class Todo {
  final String title;
  final bool completed;
  Todo(this.title, {this.completed = false});
  Todo copyWith({String? title, bool? completed}) =>
      Todo(title ?? this.title, completed: completed ?? this.completed);
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);

  void add(String title) {
    state = [...state, Todo(title)];
  }

  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(completed: !state[i].completed)
        else
          state[i],
    ];
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>(
  (ref) => TodoList(),
);

class RiverpodExamplesPage extends ConsumerWidget {
  const RiverpodExamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final userName = ref.watch(userNameProvider);
    final isDark = ref.watch(themeProvider);
    final timeAsync = ref.watch(timeProvider);
    final todos = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Gelişmiş Örnekler'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCounterExample(context, ref, counter),
            const SizedBox(height: 20),
            _buildUserNameExample(context, ref, userName),
            const SizedBox(height: 20),
            _buildThemeExample(context, ref, isDark),
            const SizedBox(height: 20),
            _buildAsyncExample(context, ref, timeAsync),
            const SizedBox(height: 20),
            _buildTodoExample(context, ref, todos),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        child: const Icon(Icons.add),
        tooltip: 'Sayaç Artır',
      ),
    );
  }

  Widget _buildCounterExample(
    BuildContext context,
    WidgetRef ref,
    int counter,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Sayaç (StateProvider)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Riverpod ile sayaç değerini güncelleme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Sayaç: $counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state--,
                  child: const Text('Azalt'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('Artır'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserNameExample(
    BuildContext context,
    WidgetRef ref,
    String userName,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Kullanıcı Adı Örneği',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Riverpod ile kullanıcı adını güncelleme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Kullanıcı Adı: $userName',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final isimler = ['Ali', 'Ayşe', 'Mehmet', 'Zeynep', 'Cengiz'];
                int index = isimler.indexOf(userName);
                String yeniIsim = isimler[(index + 1) % isimler.length];
                ref.read(userNameProvider.notifier).state = yeniIsim;
              },
              child: const Text('Adı Değiştir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeExample(BuildContext context, WidgetRef ref, bool isDark) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. Tema (StateProvider)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Riverpod ile tema (açık/koyu) değiştirme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Tema: ${isDark ? "Koyu" : "Açık"}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(themeProvider.notifier).state = !isDark,
              child: const Text('Temayı Değiştir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAsyncExample(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<String> timeAsync,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4. Asenkron Veri (FutureProvider)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Riverpod ile asenkron veri çekme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            timeAsync.when(
              data: (data) => Text('Şu anki zaman: $data'),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Hata: $e'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: timeAsync.isLoading
                  ? null
                  : () => ref.refresh(timeProvider),
              child: const Text('Yenile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoExample(
    BuildContext context,
    WidgetRef ref,
    List<Todo> todos,
  ) {
    final controller = TextEditingController();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5. Todo List (StateNotifierProvider)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Riverpod ile yapılacaklar listesi yönetimi',
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
                      ref
                          .read(todoListProvider.notifier)
                          .add(controller.text.trim());
                      controller.clear();
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...todos.asMap().entries.map((entry) {
              final i = entry.key;
              final todo = entry.value;
              return ListTile(
                leading: Checkbox(
                  value: todo.completed,
                  onChanged: (_) =>
                      ref.read(todoListProvider.notifier).toggle(i),
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
                      ref.read(todoListProvider.notifier).remove(i),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
