# Flutter setState Metodu Örnekleri

Bu proje, Flutter'da `setState` metodunun nasıl kullanılacağını gösteren kapsamlı örnekler içerir.

## setState Metodu Nedir?

`setState` metodu, Flutter'da StatefulWidget'ların durumunu güncellemek için kullanılan temel bir metoddur. Bu metod, widget'ın yeniden oluşturulmasını (rebuild) tetikler ve kullanıcı arayüzünün güncel durumu yansıtmasını sağlar.

### Temel Kullanım

```dart
setState(() {
  // Durum değişiklikleri burada yapılır
  _counter++;
  _text = "Yeni metin";
});
```

## Örnekler

### 1. Basit Sayaç Örneği
- `setState` ile sayaç değerini artırma
- En temel kullanım örneği

### 2. Metin Değiştirme Örneği
- `setState` ile metin içeriğini güncelleme
- Koşullu durum değişiklikleri

### 3. Yükleme Durumu Örneği
- `setState` ile yükleme durumunu güncelleme
- Asenkron işlemlerde güvenli kullanım

### 4. Arka Plan Rengi Değiştirme Örneği
- `setState` ile widget rengini güncelleme
- Liste üzerinde döngü ile renk değiştirme

### 5. Opacity Değiştirme Örneği
- `setState` ile şeffaflık değerini güncelleme
- Slider ile etkileşimli değişiklikler

### 6. Liste Güncelleme Örneği
- `setState` ile liste içeriğini güncelleme
- Dinamik liste işlemleri

### 7. Asenkron İşlem Örneği
- `setState` ile asenkron işlem sonuçlarını güncelleme
- `mounted` kontrolü ile güvenli kullanım

### 8. Hata Kontrolü Örneği
- `setState` çağrısında `mounted` kontrolü
- Widget dispose edildikten sonra hata önleme

## setState Kullanım Kuralları

### ✅ Doğru Kullanım

```dart
// 1. Sadece durum değişikliklerini setState içinde yapın
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}

// 2. Asenkron işlemlerde mounted kontrolü yapın
void _asyncOperation() async {
  setState(() {
    _isLoading = true;
  });
  
  await Future.delayed(Duration(seconds: 2));
  
  if (mounted) {
    setState(() {
      _isLoading = false;
    });
  }
}

// 3. Sadece gerekli durumları güncelleyin
void _updateSpecificState() {
  setState(() {
    _specificValue = newValue;
  });
}
```

### ❌ Yanlış Kullanım

```dart
// 1. setState'i async fonksiyon olarak kullanmayın
setState(() async {
  await someAsyncOperation(); // HATA!
});

// 2. setState'i dispose edilmiş widget'ta çağırmayın
void _wrongUsage() {
  // Widget dispose edildikten sonra
  setState(() {}); // HATA!
}

// 3. Gereksiz setState çağrıları yapmayın
void _unnecessarySetState() {
  setState(() {
    // Hiçbir değişiklik yok
  });
}
```

## Performans İpuçları

1. **Sadece gerekli durumları güncelleyin**: `setState` içinde sadece gerçekten değişen durumları güncelleyin.

2. **Gereksiz setState çağrılarından kaçının**: Her durum değişikliğinde `setState` çağırmayın.

3. **Asenkron işlemlerde mounted kontrolü yapın**: Widget dispose edildikten sonra `setState` çağırmamak için `mounted` özelliğini kontrol edin.

4. **Büyük listelerde optimize edin**: Büyük listelerde `setState` yerine `ListView.builder` gibi optimize edilmiş widget'lar kullanın.

## setState vs Diğer State Management Çözümleri

| Özellik | setState | Provider | Bloc | Riverpod |
|---------|----------|----------|------|----------|
| Basitlik | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| Performans | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Test Edilebilirlik | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Kod Organizasyonu | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

## Ne Zaman setState Kullanmalı?

### ✅ setState Kullanın:
- Basit durum yönetimi
- Tek widget'ta durum değişiklikleri
- Prototip geliştirme
- Küçük uygulamalar

### ❌ setState Kullanmayın:
- Karmaşık durum yönetimi
- Birden fazla widget arası durum paylaşımı
- Büyük uygulamalar
- Test edilebilirlik gerektiren projeler

## Projeyi Çalıştırma

```bash
# Bağımlılıkları yükleyin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

## Katkıda Bulunma

Bu projeye katkıda bulunmak için:

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.
