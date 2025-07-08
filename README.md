# Flutter setState Metodu Örnekleri

Bu proje, Flutter'da `setState` metodunun nasıl kullanılacağını gösteren kapsamlı örnekler içerir.

<div align="center">
  <img src="https://github.com/user-attachments/assets/b7db576b-ad00-4e34-83d5-4071181f074f" width="200" />
  <img src="https://github.com/user-attachments/assets/76bf22c3-6a73-4e97-a1f9-bacc83839e7b" width="200" />
  <img src="https://github.com/user-attachments/assets/c44e4a66-8d8b-434f-9687-1ec6832a15c9" width="200" />
  <img src="https://github.com/user-attachments/assets/d77a8a47-a7df-4332-bf0a-5df94c3a0751" width="200" />
</div>

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

🟢 Provider

Provider, Flutter ekibi tarafından önerilen basit ama etkili bir state management çözümüdür. ChangeNotifier sınıfı kullanılarak durum değişiklikleri yapılır.

Örnekler:
	•	Sayaç değeri artırma
	•	Metin güncelleme
	•	Listeye öğe ekleme
	•	Yükleme durumunun takibi

 🔴 Riverpod

Riverpod, Provider’ın daha güvenli, daha modüler ve daha esnek halidir. Test edilebilirliği yüksektir ve hata yapmayı zorlaştırır.

Örnekler:
	•	StateProvider ile sayaç kontrolü
	•	AsyncValue ile yükleme ve hata kontrolü
	•	Global erişimli durum yönetimi
	•	Temiz kod mimarisiyle durum güncelleme

 🟣 BLoC (Business Logic Component)

flutter_bloc paketi ile olay (event) ve durum (state) temelli bir yapı kurulur. Daha büyük projelerde tercih edilir. Katmanlı mimari ve test edilebilirlik avantajı sunar.

Yapı:
	•	Event sınıfları: Kullanıcı etkileşimlerini temsil eder
	•	State sınıfları: UI’nin görüntüsünü temsil eder
	•	Bloc sınıfı: İş mantığını yönetir ve uygun state’i yayar

Örnekler:
	•	Sayaç yönetimi (Increment/Decrement event’leri)
	•	Metin veya renk güncelleme event’leri
	•	Yükleme event’leri ve durum geçişleri


 ✅ Hangi Durumda Hangi Yöntem?

 Senaryo
Önerilen Yöntem
Basit sayaç, metin değişimi
setState
Küçük/orta ölçekli uygulama
Provider
Test yazmak, global state, daha güvenli yapı
Riverpod
Kurumsal projeler, event-driven yapı
BLoC


## Projeyi Çalıştırma

```bash
# Bağımlılıkları yükleyin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.
