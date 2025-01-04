import 'package:flutter/material.dart';
import '../models/kelime.dart';
import 'dart:math';
import 'quiz_sonucu_ekrani.dart';

class QuizEkrani extends StatefulWidget {
  final List<Kelime> kelimeler;
  final String kullaniciAdi;

  const QuizEkrani({super.key, required this.kelimeler, required this.kullaniciAdi});

  @override
  State<QuizEkrani> createState() => _QuizEkraniState();
}

class _QuizEkraniState extends State<QuizEkrani> {
  late final DateTime now;
  int _currentIndex = 0;
  int _dogruCevapSayisi = 0;
  bool _soruIngilizceMi = true;
  bool _cevapKontrolEdiliyor = false;
  bool? _cevapDogruMu;
  List<String> _cevapSecenekleri = [];
  List<Kelime> _secilmisKelimeler = [];
  late Kelime _aktifKelime;
  late String _kullaniciAdi;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _kullaniciAdi = widget.kullaniciAdi;
    _kelimeSecimi();
    _soruHazirla();
  }

  void _kelimeSecimi() {
    _secilmisKelimeler = widget.kelimeler.where((kelime) {
      final fark = now.difference(kelime.eklenmeTarihi);
      return fark.inDays < 56 && kelime.kullaniciAdi == _kullaniciAdi;
    }).toList();

    _secilmisKelimeler.shuffle();

    if (_secilmisKelimeler.isNotEmpty) {
      _aktifKelime = _secilmisKelimeler[_currentIndex];
    }
  }

  void _soruHazirla() {
    if (_secilmisKelimeler.isEmpty) {
      return;
    }

    _soruIngilizceMi = Random().nextBool();

    List<Kelime> yanlisKelimeler = List.from(_secilmisKelimeler);
    yanlisKelimeler.remove(_aktifKelime);
    yanlisKelimeler.shuffle();

    _cevapSecenekleri = [];

    _cevapSecenekleri.add(_soruIngilizceMi ? _aktifKelime.turkce : _aktifKelime.ingilizce);

    for (int i = 0; i < min(3,yanlisKelimeler.length); i++) {
      String yanlisCevap;
      if (_soruIngilizceMi) {
        yanlisCevap = yanlisKelimeler[i].turkce;
      } else {
        yanlisCevap = yanlisKelimeler[i].ingilizce;
      }
      if (!_cevapSecenekleri.contains(yanlisCevap)) {
        _cevapSecenekleri.add(yanlisCevap);
      }
    }
    while (_cevapSecenekleri.length < 4 && widget.kelimeler.length > 3) {
      Kelime rastgeleKelime = widget.kelimeler[Random().nextInt(widget.kelimeler.length)];
      String rastgeleCevap = _soruIngilizceMi ? rastgeleKelime.turkce : rastgeleKelime.ingilizce;
       if (!_cevapSecenekleri.contains(rastgeleCevap)) {
        _cevapSecenekleri.add(rastgeleCevap);
      }
    }

    _cevapSecenekleri.shuffle();
  }

  void _cevapKontrol(String secilenCevap) {
    if (_cevapKontrolEdiliyor) return;

    setState(() {
      _cevapKontrolEdiliyor = true;
      String dogruCevap = _soruIngilizceMi ? _aktifKelime.turkce : _aktifKelime.ingilizce;
      _cevapDogruMu = secilenCevap == dogruCevap;

      if (_cevapDogruMu!) {
        _dogruCevapSayisi++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _cevapKontrolEdiliyor = false;
        _currentIndex++;

        if (_currentIndex < _secilmisKelimeler.length) {
          _aktifKelime = _secilmisKelimeler[_currentIndex];
          _soruHazirla();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuizSonucuEkrani(
                dogruCevapSayisi: _dogruCevapSayisi,
                toplamSoruSayisi: _secilmisKelimeler.length,
                kullaniciAdi: _kullaniciAdi,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
        if (_secilmisKelimeler.isEmpty){
            return const Center(child: Text("Bu kullanıcıya ait gösterilecek kelime yok."));
        }
    return Scaffold(
      appBar: AppBar(title: const Text('Kelime Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _soruIngilizceMi ? _aktifKelime.ingilizce : _aktifKelime.turkce,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ..._cevapSecenekleri.map((cevap) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: _cevapKontrolEdiliyor ? null : () => _cevapKontrol(cevap),
                    child: Text(cevap),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}