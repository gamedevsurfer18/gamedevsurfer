import 'package:flutter/material.dart';
import 'package:wordingo/screens/quiz_ekrani.dart';
import '../models/kelime.dart';
import '../services/veri_servisi.dart';
import 'kelime_ekleme_ekrani.dart';

class KelimeListesiEkrani extends StatefulWidget {
  final String kullaniciAdi;

  const KelimeListesiEkrani({super.key, required this.kullaniciAdi});

  @override
  State<KelimeListesiEkrani> createState() => _KelimeListesiEkraniState();
}

class _KelimeListesiEkraniState extends State<KelimeListesiEkrani> {
  List<Kelime> kelimeler = [];
  bool _isLoading = true;
  String _hataMesaji = '';
  late String _kullaniciAdi;

  @override
  void initState() {
    super.initState();
    _kullaniciAdi = widget.kullaniciAdi;
    _kelimeleriYukle();
  }

  Future<void> _kelimeleriYukle() async {
    try {
      kelimeler = await VeriServisi.kelimeleriOku();
      //Kullanıcı adına göre kelimeleri filtreleme
       kelimeler = kelimeler.where((kelime) => kelime.kullaniciAdi == _kullaniciAdi).toList();
    } catch (e) {
      _hataMesaji = 'Kelimeler yüklenirken bir hata oluştu: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tersCevrilmisKelimeler = kelimeler.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelime Listesi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: () {
              if (kelimeler.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quiz başlatmak için en az 4 kelime olmalı.")));
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizEkrani(kelimeler: kelimeler, kullaniciAdi: widget.kullaniciAdi),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hataMesaji.isNotEmpty
              ? Center(child: Text(_hataMesaji))
              : kelimeler.isEmpty
                  ? const Center(child: Text("Kayıtlı kelime yok."))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: tersCevrilmisKelimeler.length,
                        itemBuilder: (context, index) {
                          final kelime = tersCevrilmisKelimeler[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(kelime.ingilizce, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text(kelime.turkce),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KelimeEklemeEkrani(
                                              duzenlenecekKelime: kelime,
                                              onKelimeEklendi: _kelimeleriYukle,
                                              kullaniciAdi: _kullaniciAdi),
                                        ),
                                      );
                                      if (result != null && result == true) {
                                        _kelimeleriYukle();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KelimeEklemeEkrani(onKelimeEklendi: _kelimeleriYukle, kullaniciAdi: _kullaniciAdi),
            ),
          );
          if (result != null && result == true) {
            _kelimeleriYukle();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}