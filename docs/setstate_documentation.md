# Flutter setState Metodu Detaylı Dokümantasyonu

## Genel Bakış

`setState` metodu, Flutter'da StatefulWidget'ların durumunu güncellemek için kullanılan temel bir metoddur. Bu metod, widget'ın yeniden oluşturulmasını (rebuild) tetikler ve kullanıcı arayüzünün güncel durumu yansıtmasını sağlar.

## Metod İmzası

```dart
@protected
void setState(VoidCallback fn)
```

### Parametreler
- `fn`: Durum değişikliklerini içeren callback fonksiyonu

### Dönüş Değeri
- `void`: Hiçbir değer döndürmez

## Temel Kullanım

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Sayaç: $_counter');
  }
}
```

## setState Nasıl Çalışır?

1. **Callback Çağrısı**: `setState` içindeki callback fonksiyonu senkron olarak çağrılır
2. **Durum Güncelleme**: Callback içinde durum değişiklikleri yapılır
3. **Rebuild Tetikleme**: Widget'ın yeniden oluşturulması planlanır
4. **UI Güncelleme**: Kullanıcı arayüzü yeni durumu yansıtacak şekilde güncellenir

## Önemli Kurallar

### 1. Senkron Callback
`setState` içindeki callback fonksiyonu senkron olmalıdır:

```dart
// ✅ Doğru
setState(() {
  _counter++;
});

// ❌ Yanlış - async callback
setState(() async {
  await someAsyncOperation();
});
```

### 2. mounted Kontrolü
Widget dispose edildikten sonra `setState` çağırmamak için `mounted` özelliğini kontrol edin:

```dart
void _asyncOperation() async {
  setState(() {
    _isLoading = true;
  });

  await Future.delayed(Duration(seconds: 2));

  // Güvenli setState çağrısı
  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
}
```

### 3. Sadece Gerekli Durumları Güncelleyin
`setState` içinde sadece gerçekten değişen durumları güncelleyin:

```dart
// ✅ Doğru - Sadece değişen durum
setState(() {
  _counter++;
});

// ❌ Yanlış - Gereksiz setState
setState(() {
  // Hiçbir değişiklik yok
});
```

## Performans Optimizasyonu

### 1. Gereksiz setState Çağrılarından Kaçının

```dart
// ❌ Yanlış - Her frame'de setState
void _wrongUsage() {
  Timer.periodic(Duration(milliseconds: 16), (timer) {
    setState(() {
      // Gereksiz güncelleme
    });
  });
}

// ✅ Doğru - Sadece gerektiğinde setState
void _correctUsage() {
  Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      _time = DateTime.now();
    });
  });
}
```

### 2. Büyük Listelerde Optimize Edin

```dart
// ❌ Yanlış - Tüm listeyi yeniden oluştur
setState(() {
  _items = List.generate(1000, (index) => 'Item $index');
});

// ✅ Doğru - Sadece değişen öğeyi güncelle
setState(() {
  _items[index] = newValue;
});
```

### 3. Koşullu setState

```dart
void _updateIfNeeded(String newValue) {
  if (_currentValue != newValue) {
    setState(() {
      _currentValue = newValue;
    });
  }
}
```

## Asenkron İşlemlerde setState

### Doğru Yaklaşım

```dart
class _MyWidgetState extends State<MyWidget> {
  bool _isLoading = false;
  String _data = '';

  Future<void> _loadData() async {
    // 1. Yükleme durumunu ayarla
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Asenkron işlemi gerçekleştir
      final result = await fetchData();

      // 3. Sonucu güvenli şekilde güncelle
      if (mounted) {
        setState(() {
          _data = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      // 4. Hata durumunda da güvenli güncelleme
      if (mounted) {
        setState(() {
          _data = 'Hata: $e';
          _isLoading = false;
        });
      }
    }
  }
}
```

### Yanlış Yaklaşım

```dart
// ❌ Yanlış - setState içinde async işlem
void _wrongAsyncUsage() {
  setState(() async {
    _data = await fetchData(); // HATA!
  });
}
```

## setState vs Diğer State Management

### setState Kullanım Alanları

| Durum | setState | Provider | Bloc | Riverpod |
|-------|----------|----------|------|----------|
| Basit durum yönetimi | ✅ | ✅ | ✅ | ✅ |
| Tek widget durumu | ✅ | ✅ | ✅ | ✅ |
| Prototip geliştirme | ✅ | ✅ | ✅ | ✅ |
| Küçük uygulamalar | ✅ | ✅ | ✅ | ✅ |
| Karmaşık durum yönetimi | ❌ | ✅ | ✅ | ✅ |
| Birden fazla widget | ❌ | ✅ | ✅ | ✅ |
| Test edilebilirlik | ❌ | ✅ | ✅ | ✅ |

## Hata Yönetimi

### Yaygın Hatalar ve Çözümleri

#### 1. setState after dispose

```dart
// ❌ Hata
class _MyWidgetState extends State<MyWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Widget dispose edildikten sonra hata
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer'ı iptal et
    super.dispose();
  }
}
```

#### 2. setState in constructor

```dart
// ❌ Hata
class _MyWidgetState extends State<MyWidget> {
  _MyWidgetState() {
    setState(() {}); // Constructor'da setState çağrılamaz
  }
}
```

#### 3. setState in build method

```dart
// ❌ Hata
@override
Widget build(BuildContext context) {
  setState(() {}); // Build method'da setState çağrılamaz
  return Container();
}
```

## Best Practices

### 1. Durum Değişikliklerini Gruplandırın

```dart
// ✅ Doğru - Tek setState çağrısı
void _updateMultipleStates() {
  setState(() {
    _counter++;
    _lastUpdated = DateTime.now();
    _isDirty = true;
  });
}

// ❌ Yanlış - Birden fazla setState çağrısı
void _wrongMultipleSetState() {
  setState(() {
    _counter++;
  });
  setState(() {
    _lastUpdated = DateTime.now();
  });
  setState(() {
    _isDirty = true;
  });
}
```

### 2. Durum Değişikliklerini Açıklayın

```dart
void _updateAnimation() {
  setState(() {
    // Animasyon durumu değişti
    _animationValue = _controller.value;
  });
}
```

### 3. Durum Değişikliklerini Doğrulayın

```dart
void _updateCounter(int newValue) {
  if (newValue != _counter) {
    setState(() {
      _counter = newValue;
    });
  }
}
```

## Debugging setState

### setState Debugging İpuçları

```dart
class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  void _incrementCounter() {
    print('setState öncesi: $_counter');
    setState(() {
      _counter++;
    });
    print('setState sonrası: $_counter');
  }

  @override
  Widget build(BuildContext context) {
    print('Build çağrıldı, counter: $_counter');
    return Text('Sayaç: $_counter');
  }
}
```

### setState Profiling

```dart
class _MyWidgetState extends State<MyWidget> {
  int _setStateCallCount = 0;

  void _trackedSetState(VoidCallback fn) {
    _setStateCallCount++;
    print('setState çağrısı #$_setStateCallCount');
    setState(fn);
  }
}
```

## Sonuç

`setState` metodu, Flutter'da durum yönetiminin temelidir. Doğru kullanıldığında güçlü ve etkili bir araçtır, ancak yanlış kullanıldığında performans sorunlarına ve hatalara neden olabilir. Bu dokümantasyonda belirtilen kuralları ve best practice'leri takip ederek `setState`'i etkili bir şekilde kullanabilirsiniz. 