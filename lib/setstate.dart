import 'package:flutter/material.dart';

class SetStateExamplesPage extends StatefulWidget {
  const SetStateExamplesPage({super.key});

  @override
  State<SetStateExamplesPage> createState() => _SetStateExamplesPageState();
}

class _SetStateExamplesPageState extends State<SetStateExamplesPage> {
  int _counter = 0;
  String _text = "Merhaba Dünya";
  bool _isLoading = false;
  Color _backgroundColor = Colors.white;
  double _opacity = 1.0;
  List<String> _items = ['Öğe 1', 'Öğe 2', 'Öğe 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState Metodu Örnekleri'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Basit Sayaç Örneği
            _buildExampleCard(
              title: '1. Basit Sayaç Örneği',
              description: 'setState ile sayaç değerini güncelleme',
              child: Column(
                children: [
                  Text(
                    'Sayaç: $_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    child: const Text('Artır'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Metin Değiştirme Örneği
            _buildExampleCard(
              title: '2. Metin Değiştirme Örneği',
              description: 'setState ile metin içeriğini güncelleme',
              child: Column(
                children: [
                  Text(_text, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _changeText,
                    child: const Text('Metni Değiştir'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. Yükleme Durumu Örneği
            _buildExampleCard(
              title: '3. Yükleme Durumu Örneği',
              description: 'setState ile yükleme durumunu güncelleme',
              child: Column(
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.blue)
                  else
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50,
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _simulateLoading,
                    child: Text(
                      _isLoading ? 'Yükleniyor...' : 'Yükleme Simülasyonu',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Arka Plan Rengi Değiştirme Örneği
            _buildExampleCard(
              title: '4. Arka Plan Rengi Değiştirme Örneği',
              description: 'setState ile widget rengini güncelleme',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    const Text('Bu kutunun rengi değişiyor'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _changeBackgroundColor,
                      child: const Text('Rengi Değiştir'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 5. Opacity Değiştirme Örneği
            _buildExampleCard(
              title: '5. Opacity Değiştirme Örneği',
              description: 'setState ile şeffaflık değerini güncelleme',
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          'Şeffaf',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: _opacity,
                    onChanged: _changeOpacity,
                    min: 0.0,
                    max: 1.0,
                  ),
                  Text('Opaklık: ${(_opacity * 100).round()}%'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 6. Liste Güncelleme Örneği
            _buildExampleCard(
              title: '6. Liste Güncelleme Örneği',
              description: 'setState ile liste içeriğini güncelleme',
              child: Column(
                children: [
                  ..._items.map(
                    (item) => ListTile(
                      title: Text(item),
                      leading: const Icon(Icons.list),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _addItem,
                        child: const Text('Öğe Ekle'),
                      ),
                      ElevatedButton(
                        onPressed: _items.isNotEmpty ? _removeItem : null,
                        child: const Text('Öğe Çıkar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 7. Asenkron İşlem Örneği
            _buildExampleCard(
              title: '7. Asenkron İşlem Örneği',
              description: 'setState ile asenkron işlem sonuçlarını güncelleme',
              child: Column(
                children: [
                  Text('Sonuç: $_text'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _performAsyncOperation,
                    child: const Text('Asenkron İşlem Başlat'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 8. Hata Kontrolü Örneği
            _buildExampleCard(
              title: '8. Hata Kontrolü Örneği',
              description: 'setState çağrısında mounted kontrolü',
              child: Column(
                children: [
                  const Text(
                    'Widget dispose edildikten sonra setState çağrılmamalı',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _safeSetState,
                    child: const Text('Güvenli setState'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // 1. Basit sayaç artırma
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // 2. Metin değiştirme
  void _changeText() {
    setState(() {
      _text = _text == "Merhaba Dünya" ? "Merhaba Flutter!" : "Merhaba Dünya";
    });
  }

  // 3. Yükleme durumu simülasyonu
  void _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });

    // Asenkron işlem simülasyonu
    await Future.delayed(const Duration(seconds: 2));

    // setState'i güvenli şekilde çağır
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 4. Arka plan rengi değiştirme
  void _changeBackgroundColor() {
    setState(() {
      final colors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
        Colors.purple,
      ];
      int nextIndex = 0;
      for (int i = 0; i < colors.length; i++) {
        if (colors[i] == _backgroundColor) {
          nextIndex = (i + 1) % colors.length;
          break;
        }
      }
      _backgroundColor = colors[nextIndex];
    });
  }

  // 5. Opacity değiştirme
  void _changeOpacity(double value) {
    setState(() {
      _opacity = value;
    });
  }

  // 6. Liste işlemleri
  void _addItem() {
    setState(() {
      _items.add('Öğe ${_items.length + 1}');
    });
  }

  void _removeItem() {
    setState(() {
      if (_items.isNotEmpty) {
        _items.removeLast();
      }
    });
  }

  // 7. Asenkron işlem örneği
  void _performAsyncOperation() async {
    setState(() {
      _text = "İşlem başlatılıyor...";
    });

    // Asenkron işlem
    await Future.delayed(const Duration(seconds: 1));

    // setState'i güvenli şekilde çağır
    if (mounted) {
      setState(() {
        _text =
            "İşlem tamamlandı! Zaman: ${DateTime.now().toString().substring(11, 19)}";
      });
    }
  }

  // 8. Güvenli setState örneği
  void _safeSetState() {
    // mounted kontrolü ile güvenli setState
    if (mounted) {
      setState(() {
        _counter += 10;
      });
    }
  }
}
