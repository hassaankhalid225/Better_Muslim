import 'package:equatable/equatable.dart';

/// Surah Model
/// Represents a chapter (Surah) from the Quran
class SurahModel extends Equatable {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final int numberOfAyahs;
  final String revelationType; // Meccan or Medinan
  final List<AyahModel> ayahs;

  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.ayahs,
  });

  @override
  List<Object?> get props => [
        number,
        nameArabic,
        nameEnglish,
        nameTransliteration,
        numberOfAyahs,
        revelationType,
        ayahs,
      ];
}

/// Ayah Model
/// Represents a verse (Ayah) from the Quran
class AyahModel extends Equatable {
  final int number;
  final int numberInSurah;
  final String textArabic;
  final String textEnglish;

  const AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.textArabic,
    required this.textEnglish,
  });

  @override
  List<Object?> get props => [
        number,
        numberInSurah,
        textArabic,
        textEnglish,
      ];
}
