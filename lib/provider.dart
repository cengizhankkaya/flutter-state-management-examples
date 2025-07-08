import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 1. Basit bir ChangeNotifier ve Provider kullanımı
class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

/// 2. Birden fazla Provider kullanımı (MultiProvider örneği)
class UserModel with ChangeNotifier {
  String _name = "Kullanıcı";

  String get name => _name;

  void changeName(String newName) {
    _name = newName;
    notifyListeners();
  }
}

/// 3. Provider ile veri güncelleme ve dinleme örneği
class ThemeModel with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

class ProviderExamplesPage extends StatelessWidget {
  const ProviderExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Örnekleri'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCounterExample(context),
            const SizedBox(height: 20),
            _buildUserModelExample(context),
            const SizedBox(height: 20),
            _buildThemeModelExample(context),
          ],
        ),
      ),
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
              '1. Sayaç (Counter) Örneği',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Provider ile sayaç değerini güncelleme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Consumer<Counter>(
              builder: (context, counter, _) => Column(
                children: [
                  Text(
                    'Sayaç: ${counter.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: counter.increment,
                    child: const Text('Artır'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserModelExample(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. Kullanıcı (UserModel) Örneği',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Provider ile kullanıcı adını güncelleme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Consumer<UserModel>(
              builder: (context, user, _) => Column(
                children: [
                  Text(
                    'Kullanıcı Adı: ${user.name}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Farklı isimler listesi
                      final isimler = [
                        "Ali",
                        "Ayşe",
                        "Mehmet",
                        "Zeynep",
                        "Cengiz",
                      ];
                      // Şu anki ismin indexini bul
                      int index = isimler.indexOf(user.name);
                      // Sonraki ismi seç (döngüsel)
                      String yeniIsim = isimler[(index + 1) % isimler.length];
                      user.changeName(yeniIsim);
                    },
                    child: const Text('Adı Değiştir'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModelExample(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. Tema (ThemeModel) Örneği',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Provider ile tema (açık/koyu) değiştirme',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Consumer<ThemeModel>(
              builder: (context, theme, _) => Column(
                children: [
                  Text(
                    'Tema: ${theme.isDark ? "Koyu" : "Açık"}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: theme.toggleTheme,
                    child: const Text('Temayı Değiştir'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
