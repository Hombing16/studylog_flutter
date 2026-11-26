# STUDYLOG — Portal Mahasiswa (Siap Jalankan di Android Studio)

Proyek Flutter lengkap untuk aplikasi **STUDYLOG** (Dashboard, KRS, Tugas, Jadwal & KHS, Profil) yang telah diperbarui agar kompatibel dengan **Flutter 3.47.5**, **Gradle 8.14**, **Android Gradle Plugin (AGP) 8.11.1**, **Kotlin 2.1.0**, dan **Java 17**.

## Cara Menjalankan di Android Studio
1. Ekstrak file `studylog_flutter_fixed.zip` sehingga mendapatkan folder `studylog_flutter` (yang langsung berisi `pubspec.yaml`, folder `lib/`, dan folder `android/`).
2. Buka **Android Studio** -> klik **Open** -> pilih folder `studylog_flutter`.
3. Buka tab **Terminal** di bagian bawah Android Studio, lalu jalankan:
   ```powershell
   flutter create .
   flutter pub get
   ```
   *(Perintah `flutter create .` akan melengkapi `gradlew`, `gradle-wrapper.jar`, dan `local.properties` tanpa menimpa konfigurasi Gradle maupun kode di `lib/`).*
4. Pastikan perangkat HP Android Anda (dengan **USB Debugging** aktif) atau **Android Emulator** sudah terpilih di toolbar atas Android Studio.
5. Klik tombol **Run (▶)** berwarna hijau atau ketik `flutter run` di terminal.
