import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'provider.dart';
import 'setstate.dart';
import 'reverpod.dart';
import 'bloc.dart';

void main() {
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (_) => Counter()),
          provider.ChangeNotifierProvider(create: (_) => UserModel()),
          provider.ChangeNotifierProvider(create: (_) => ThemeModel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          title: 'State Management Örnekleri',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: false,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.amber,
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    SetStateExamplesPage(),
    ProviderExamplesPage(),
    RiverpodExamplesPage(),
    BlocExamplesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.grey,
        height: 70,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.refresh),
              label: 'setState',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.extension),
              label: 'Provider',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart),
              label: 'Riverpod',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_tree),
              label: 'Bloc',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
