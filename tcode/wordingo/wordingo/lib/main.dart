import 'package:flutter/material.dart';
import 'screens/giris_ekrani.dart'; // Giriş ekranını import edin

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordingo',
      home: const GirisEkrani(), // Başlangıç ekranı Giriş Ekranı
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Indigo rengi ana renk olarak
        primaryColor: Colors.indigo[800], // Daha koyu bir indigo tonu
        hintColor: Colors.grey[400],
        scaffoldBackgroundColor: Colors.grey[100], // Açık gri arka plan
        fontFamily: 'Roboto', // Roboto fontunu kullan
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87), // Normal metin
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Büyük başlık
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[400],
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo, width: 2), borderRadius: BorderRadius.circular(8)),
        ),
        cardTheme: CardTheme(
          elevation: 4, // Card yüksekliği
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}