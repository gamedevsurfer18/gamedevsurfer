import 'package:flutter/material.dart';

import '../models/kelime.dart';

import '../services/veri_servisi.dart';



class KelimeEklemeEkrani extends StatefulWidget {

  final Kelime? duzenlenecekKelime;

  final VoidCallback onKelimeEklendi;

  final String kullaniciAdi;

  const KelimeEklemeEkrani({

   super.key,

   this.duzenlenecekKelime,

   required this.onKelimeEklendi,

   required this.kullaniciAdi,

  });



  @override

  State<KelimeEklemeEkrani> createState() => _KelimeEklemeEkraniState();

}



class _KelimeEklemeEkraniState extends State<KelimeEklemeEkrani> {

  final _formKey = GlobalKey<FormState>();

  final _ingilizceController = TextEditingController();

  final _turkceController = TextEditingController();

  late String _kullaniciAdi;



  @override

  void initState() {

   super.initState();

   // initState içinde widget'lara doğrudan erişimden kaçınıyoruz.

  }



  @override

  void didChangeDependencies() {

   super.didChangeDependencies();

   _kullaniciAdi = widget.kullaniciAdi; // Artık burada güvenle kullanabiliriz.

   if (widget.duzenlenecekKelime != null) {

        _ingilizceController.text = widget.duzenlenecekKelime!.ingilizce;

        _turkceController.text = widget.duzenlenecekKelime!.turkce;

   }

  }



  @override

  void dispose() {

   _ingilizceController.dispose();

   _turkceController.dispose();

   super.dispose();

  }



  // Kelime ekleme/düzenleme mantığı buraya gelecek (önceki yanıtlarda verilmişti).

  void _kelimeEkle() async {

   final ingilizce = _ingilizceController.text;

   final turkce = _turkceController.text;



   if (ingilizce.isNotEmpty && turkce.isNotEmpty) {

        try {

     if (widget.duzenlenecekKelime != null) {

      // DÜZENLEME İŞLEMİ

      final guncellenmisKelime = Kelime(

        id: widget.duzenlenecekKelime!.id,

        ingilizce: ingilizce,

        turkce: turkce,

        eklenmeTarihi: DateTime.now(),

        kullaniciAdi: widget.kullaniciAdi,

         yanlisAnlamlar: widget.duzenlenecekKelime!.yanlisAnlamlar

      );



      await VeriServisi.kelimeGuncelle(guncellenmisKelime);

      // ... (diğer kodlar aynı kalıyor)

     } else {

      // YENİ EKLEME İŞLEMİ

      final yeniKelime = Kelime(

        ingilizce: ingilizce,

        turkce: turkce,

        eklenmeTarihi: DateTime.now(),

        kullaniciAdi: widget.kullaniciAdi,

      );

      await VeriServisi.kelimeEkle(yeniKelime);

      // ... (diğer kodlar aynı kalıyor)

     }

       if (mounted) {

      widget.onKelimeEklendi();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem Başarılı')));

     }

        } catch (e) {

     debugPrint("Kelime kaydetme sırasında hata oluştu: $e");

     if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kelime kaydedilirken bir hata oluştu: $e')));

     }

        }

   } else {

        if (mounted) {

     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen İngilizce kelime ve Türkçe anlam girin!')));

        }

   }

  }



  @override

  Widget build(BuildContext context) {

   return Scaffold(

        appBar: AppBar(

     title: Text(widget.duzenlenecekKelime == null ? 'Kelime Ekle' : 'Kelime Düzenle'),

        ),

        body: Padding(

     padding: const EdgeInsets.all(16.0),

     child: Form(

      key: _formKey,

      child: Column(

        children: [

          TextFormField(

           controller: _ingilizceController,

           decoration: const InputDecoration(labelText: 'İngilizce Kelime:'),

           validator: (value) {

                if (value == null || value.isEmpty) {

             return 'Lütfen İngilizce bir kelime girin';

                }

                return null;

           },

          ),

          TextFormField(

           controller: _turkceController,

           decoration: const InputDecoration(labelText: 'Türkçe Anlam:'),

           validator: (value) {

                if (value == null || value.isEmpty) {

             return 'Lütfen Türkçe bir anlam girin';

                }

                return null;

           },

          ),

          const SizedBox(height: 20),

          ElevatedButton(

           onPressed: () {

                if (_formKey.currentState!.validate()) {

             _kelimeEkle();

                }

           },

           child: Text(widget.duzenlenecekKelime == null ? 'Kaydet' : 'Düzenle'),

          ),

        ],

      ),

     ),

        ),

   );

  }

}

  @override
  void dispose() {
    _ingilizceController.dispose();
    _turkceController.dispose();
    super.dispose();
  }

  void _kelimeEkle() async {
    if (_formKey.currentState!.validate()) {
      final ingilizce = _ingilizceController.text;
      final turkce = _turkceController.text;
      var uuid = const Uuid();

      try {
        final kelime = Kelime(
          id: widget.duzenlenecekKelime?.id ?? uuid.v4().hashCode,
          ingilizce: ingilizce,
          turkce: turkce,
          eklenmeTarihi: DateTime.now(),
          kullaniciAdi: widget.kullaniciAdi,
          yanlisAnlamlar: widget.duzenlenecekKelime?.yanlisAnlamlar ?? [],
        );

        if (widget.duzenlenecekKelime != null) {
          await VeriServisi.kelimeGuncelle(kelime);
        } else {
          await VeriServisi.kelimeEkle(kelime);
        }

        if (mounted) {
          widget.onKelimeEklendi();
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem Başarılı')));
        }
      } catch (e) {
        debugPrint("Kelime kaydetme sırasında hata oluştu: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kelime kaydedilirken bir hata oluştu: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.duzenlenecekKelime == null ? 'Kelime Ekle' : 'Kelime Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ... (TextFormField'lar ve ElevatedButton aynı)
              ElevatedButton(
                onPressed: _kelimeEkle,
                child: Text(widget.duzenlenecekKelime == null ? 'Kaydet' : 'Düzenle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}