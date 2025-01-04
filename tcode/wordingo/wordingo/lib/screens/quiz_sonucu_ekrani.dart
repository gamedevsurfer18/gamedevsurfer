import 'package:flutter/material.dart';

class QuizSonucuEkrani extends StatelessWidget {
  final String kullaniciAdi;
  final int dogruCevapSayisi;
  final int toplamSoruSayisi;

  const QuizSonucuEkrani({
    super.key,
    required this.kullaniciAdi,
    required this.dogruCevapSayisi,
    required this.toplamSoruSayisi,
  });

  @override
  Widget build(BuildContext context) {
    double dogrulukOrani = toplamSoruSayisi > 0 ? (dogruCevapSayisi / toplamSoruSayisi) : 0;
    String mesaj = "";
    String altMesaj = "";

    if (dogrulukOrani > 0.9) {
      mesaj = "Mükemmeldin!";
      altMesaj = "Mükemmel öğrenmişsin 10-15 tane yeni kelime eklemeyi denemelisin!";
    } else if (dogrulukOrani > 0.8) {
      mesaj = "Çok İyiydin!";
      altMesaj = "Çok iyi öğrenmişsin 5-10 tane yeni kelime eklemeyi denemelisin!";
    } else if (dogrulukOrani > 0.65) {
      mesaj = "İyiydin!";
      altMesaj = "İyi öğrenmişsin 5-6 tane yeni kelime eklemeyi denemelisin!";
    } else if (dogrulukOrani > 0.5) {
      mesaj = "Fena değilsin!";
      altMesaj = "Biraz daha quiz çözmeyi deneyebilirsin. 1-2 tane yeni kelime eklemeyi denemende sakınca yok!";
    } else if (dogrulukOrani > 0.3) {
      mesaj = "İlerleme var!";
      altMesaj = "Quiz çözmeye devam et! Merak etme daha iyi olacaksın!";
    } else {
      mesaj = "Yolun Başındasın!";
      altMesaj = "Quiz çözmeye devam et! İlerlemek çok kolay olacak!";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Sonucu"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Merhaba $kullaniciAdi!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text("Doğru Cevap Sayısı: $dogruCevapSayisi", style: const TextStyle(fontSize: 18)),
              Text("Toplam Soru Sayısı: $toplamSoruSayisi", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text(mesaj, style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
              Text(altMesaj, textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}