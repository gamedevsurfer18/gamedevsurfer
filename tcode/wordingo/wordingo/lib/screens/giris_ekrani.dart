import 'package:flutter/material.dart';
import 'kelime_listesi_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _kullaniciAdiController = TextEditingController();

  @override
  void dispose() {
    _kullaniciAdiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _kullaniciAdiController,
              decoration: const InputDecoration(labelText: "Kullanıcı Adı"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final kullaniciAdi = _kullaniciAdiController.text;
                if (kullaniciAdi.isNotEmpty) {
                  Navigator.pushReplacement( // Geri tuşuyla giriş ekranına dönülmemesi için
                    context,
                    MaterialPageRoute(
                      builder: (context) => KelimeListesiEkrani(kullaniciAdi: kullaniciAdi),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lütfen bir kullanıcı adı girin.")),
                  );
                }
              },
              child: const Text("Giriş"),
            ),
          ],
        ),
      ),
    );
  }
}