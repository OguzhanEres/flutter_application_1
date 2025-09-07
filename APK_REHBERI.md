# HaberCraft Pro - APK Oluşturma Rehberi

## 📱 Android APK Oluşturmak İçin:

### 1. Android Studio Kurulumu
1. https://developer.android.com/studio adresinden Android Studio indirin
2. Kurulum sırasında "Android SDK" seçeneğini işaretleyin
3. İlk açılışta SDK bileşenlerini kurun

### 2. Flutter Android Kurulumu
```bash
# Android lisansları kabul edin
flutter doctor --android-licenses

# APK oluşturun (Release versiyonu)
flutter build apk --release

# Veya Debug APK (daha hızlı)
flutter build apk --debug
```

### 3. APK Konumu
APK dosyası şu konumda oluşacak:
`build/app/outputs/flutter-apk/app-release.apk`

## 🌐 Web Versiyonu (Şu anda hazır)
Web versiyonu `build/web` klasöründe hazır. Bu klasörü bir web sunucusuna yükleyerek kullanabilirsiniz.

## 📋 Özellikler
- ✅ Interaktif haber okuma
- ✅ TEKNOFEST reels içeriği
- ✅ Harita entegrasyonu
- ✅ Başlık önerme sistemi
- ✅ Oyunlar ve keşfet bölümleri
- ✅ Modern Material Design 3 UI

## 🛠️ Geliştirme Notları
- Flutter 3.29.2 ile geliştirildi
- Web ve Android platformları destekleniyor
- Responsive tasarım
- Modern UI/UX deneyimi
