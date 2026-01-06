class Ayah {
  final int id;
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final String arabicText;
  final String englishText;
  final String reference;

  Ayah({
    required this.id,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabicText,
    required this.englishText,
    required this.reference,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'] as int,
      surahName: json['surah_name'] as String,
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      arabicText: json['arabic_text'] as String,
      englishText: json['english_text'] as String,
      reference: json['reference'] as String,
    );
  }
}

class Hadith {
  final int id;
  final String source;
  final String text;
  final String narrator;

  Hadith({
    required this.id,
    required this.source,
    required this.text,
    required this.narrator,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as int,
      source: json['source'] as String,
      text: json['text'] as String,
      narrator: json['narrator'] as String,
    );
  }
}
