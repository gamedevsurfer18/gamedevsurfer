class Kelime {
  int? id;
  String ingilizce;
  String turkce;
  DateTime eklenmeTarihi;
  List<String> yanlisAnlamlar;
  String kullaniciAdi; // Kullanıcı adı artık zorunlu

  Kelime({
    this.id,
    required this.ingilizce,
    required this.turkce,
    required this.eklenmeTarihi,
    this.yanlisAnlamlar = const [],
    required this.kullaniciAdi, // Kullanıcı adı artık zorunlu
  });

  factory Kelime.fromJson(Map<String, dynamic> json) => Kelime(
    id: json['id'],
    ingilizce: json['ingilizce'],
    turkce: json['turkce'],
    eklenmeTarihi: DateTime.parse(json['eklenmeTarihi']),
    yanlisAnlamlar: json['yanlisAnlamlar'] != null
        ? List<String>.from(json['yanlisAnlamlar'])
        : [],
    kullaniciAdi: json['kullaniciAdi'] ?? "User", // JSON'dan kullanıcı adını oku veya varsayılan değer kullan
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'ingilizce': ingilizce,
    'turkce': turkce,
    'eklenmeTarihi': eklenmeTarihi.toIso8601String(),
    'yanlisAnlamlar': yanlisAnlamlar,
    'kullaniciAdi': kullaniciAdi,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Kelime && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}