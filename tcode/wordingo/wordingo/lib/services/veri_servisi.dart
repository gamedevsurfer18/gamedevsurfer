import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/kelime.dart';

class VeriServisi {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/kelimeler.json');
  }

  static Future<List<Kelime>> kelimeleriOku() async {
    try {
      final file = await _localFile;
      final stringData = await file.readAsString();
      if (stringData.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(stringData) as List;
      return jsonList.map((item) => Kelime.fromJson(item)).toList();
    } catch (e) {
      // Hata yakalama ve loglama ekleyebilirsiniz (isteğe bağlı)
      return [];
    }
  }

  static Future<void> kelimeEkle(Kelime kelime) async {
    List<Kelime> mevcutKelimeler = await kelimeleriOku();
    mevcutKelimeler.add(kelime);
    await kelimeleriKaydet(mevcutKelimeler);
  }

  static Future<void> kelimeGuncelle(Kelime kelime) async {
    List<Kelime> mevcutKelimeler = await kelimeleriOku();
    int index = mevcutKelimeler.indexWhere((element) => element.id==kelime.id);
    if(index!=-1){
      mevcutKelimeler[index]=kelime;
    }
    await kelimeleriKaydet(mevcutKelimeler);
  }

  static Future<void> kelimeleriKaydet(List<Kelime> kelimeler) async {
    final file = await _localFile;
    final jsonList = kelimeler.map((kelime) => kelime.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}