import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../domain/models/surah_model.dart';

/// Quran Service
/// Fetches Quran data from API for Surahs 1-50
class QuranService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  /// Get list of available Surahs (1-50)
  List<SurahModel> getAvailableSurahs() {
    return [
      SurahModel(number: 1, nameArabic: 'الفاتحة', nameEnglish: 'The Opening', nameTransliteration: 'Al-Fatihah', numberOfAyahs: 7, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 2, nameArabic: 'البقرة', nameEnglish: 'The Cow', nameTransliteration: 'Al-Baqarah', numberOfAyahs: 286, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 3, nameArabic: 'آل عمران', nameEnglish: 'Family of Imran', nameTransliteration: "Ali 'Imran", numberOfAyahs: 200, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 4, nameArabic: 'النساء', nameEnglish: 'The Women', nameTransliteration: 'An-Nisa', numberOfAyahs: 176, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 5, nameArabic: 'المائدة', nameEnglish: 'The Table Spread', nameTransliteration: "Al-Ma'idah", numberOfAyahs: 120, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 6, nameArabic: 'الأنعام', nameEnglish: 'The Cattle', nameTransliteration: "Al-An'am", numberOfAyahs: 165, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 7, nameArabic: 'الأعراف', nameEnglish: 'The Heights', nameTransliteration: "Al-A'raf", numberOfAyahs: 206, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 8, nameArabic: 'الأنفال', nameEnglish: 'The Spoils of War', nameTransliteration: 'Al-Anfal', numberOfAyahs: 75, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 9, nameArabic: 'التوبة', nameEnglish: 'The Repentance', nameTransliteration: 'At-Tawbah', numberOfAyahs: 129, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 10, nameArabic: 'يونس', nameEnglish: 'Jonah', nameTransliteration: 'Yunus', numberOfAyahs: 109, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 11, nameArabic: 'هود', nameEnglish: 'Hud', nameTransliteration: 'Hud', numberOfAyahs: 123, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 12, nameArabic: 'يوسف', nameEnglish: 'Joseph', nameTransliteration: 'Yusuf', numberOfAyahs: 111, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 13, nameArabic: 'الرعد', nameEnglish: 'The Thunder', nameTransliteration: "Ar-Ra'd", numberOfAyahs: 43, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 14, nameArabic: 'ابراهيم', nameEnglish: 'Abraham', nameTransliteration: 'Ibrahim', numberOfAyahs: 52, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 15, nameArabic: 'الحجر', nameEnglish: 'The Rocky Tract', nameTransliteration: 'Al-Hijr', numberOfAyahs: 99, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 16, nameArabic: 'النحل', nameEnglish: 'The Bee', nameTransliteration: 'An-Nahl', numberOfAyahs: 128, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 17, nameArabic: 'الإسراء', nameEnglish: 'The Night Journey', nameTransliteration: 'Al-Isra', numberOfAyahs: 111, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 18, nameArabic: 'الكهف', nameEnglish: 'The Cave', nameTransliteration: 'Al-Kahf', numberOfAyahs: 110, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 19, nameArabic: 'مريم', nameEnglish: 'Mary', nameTransliteration: 'Maryam', numberOfAyahs: 98, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 20, nameArabic: 'طه', nameEnglish: 'Ta-Ha', nameTransliteration: 'Ta-Ha', numberOfAyahs: 135, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 21, nameArabic: 'الأنبياء', nameEnglish: 'The Prophets', nameTransliteration: 'Al-Anbya', numberOfAyahs: 112, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 22, nameArabic: 'الحج', nameEnglish: 'The Pilgrimage', nameTransliteration: 'Al-Hajj', numberOfAyahs: 78, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 23, nameArabic: 'المؤمنون', nameEnglish: 'The Believers', nameTransliteration: "Al-Mu'minun", numberOfAyahs: 118, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 24, nameArabic: 'النور', nameEnglish: 'The Light', nameTransliteration: 'An-Nur', numberOfAyahs: 64, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 25, nameArabic: 'الفرقان', nameEnglish: 'The Criterion', nameTransliteration: 'Al-Furqan', numberOfAyahs: 77, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 26, nameArabic: 'الشعراء', nameEnglish: 'The Poets', nameTransliteration: "Ash-Shu'ara", numberOfAyahs: 227, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 27, nameArabic: 'النمل', nameEnglish: 'The Ant', nameTransliteration: 'An-Naml', numberOfAyahs: 93, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 28, nameArabic: 'القصص', nameEnglish: 'The Stories', nameTransliteration: 'Al-Qasas', numberOfAyahs: 88, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 29, nameArabic: 'العنكبوت', nameEnglish: 'The Spider', nameTransliteration: "Al-'Ankabut", numberOfAyahs: 69, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 30, nameArabic: 'الروم', nameEnglish: 'The Romans', nameTransliteration: 'Ar-Rum', numberOfAyahs: 60, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 31, nameArabic: 'لقمان', nameEnglish: 'Luqman', nameTransliteration: 'Luqman', numberOfAyahs: 34, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 32, nameArabic: 'السجدة', nameEnglish: 'The Prostration', nameTransliteration: 'As-Sajdah', numberOfAyahs: 30, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 33, nameArabic: 'الأحزاب', nameEnglish: 'The Combined Forces', nameTransliteration: 'Al-Ahzab', numberOfAyahs: 73, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 34, nameArabic: 'سبإ', nameEnglish: 'Sheba', nameTransliteration: 'Saba', numberOfAyahs: 54, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 35, nameArabic: 'فاطر', nameEnglish: 'Originator', nameTransliteration: 'Fatir', numberOfAyahs: 45, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 36, nameArabic: 'يس', nameEnglish: 'Ya-Sin', nameTransliteration: 'Ya-Sin', numberOfAyahs: 83, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 37, nameArabic: 'الصافات', nameEnglish: 'Those who set the Ranks', nameTransliteration: 'As-Saffat', numberOfAyahs: 182, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 38, nameArabic: 'ص', nameEnglish: 'The Letter Sad', nameTransliteration: 'Sad', numberOfAyahs: 88, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 39, nameArabic: 'الزمر', nameEnglish: 'The Troops', nameTransliteration: 'Az-Zumar', numberOfAyahs: 75, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 40, nameArabic: 'غافر', nameEnglish: 'The Forgiver', nameTransliteration: 'Ghafir', numberOfAyahs: 85, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 41, nameArabic: 'فصلت', nameEnglish: 'Explained in Detail', nameTransliteration: 'Fussilat', numberOfAyahs: 54, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 42, nameArabic: 'الشورى', nameEnglish: 'The Consultation', nameTransliteration: 'Ash-Shuraa', numberOfAyahs: 53, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 43, nameArabic: 'الزخرف', nameEnglish: 'The Ornaments of Gold', nameTransliteration: 'Az-Zukhruf', numberOfAyahs: 89, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 44, nameArabic: 'الدخان', nameEnglish: 'The Smoke', nameTransliteration: 'Ad-Dukhan', numberOfAyahs: 59, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 45, nameArabic: 'الجاثية', nameEnglish: 'The Crouching', nameTransliteration: 'Al-Jathiyah', numberOfAyahs: 37, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 46, nameArabic: 'الأحقاف', nameEnglish: 'The Wind-Curved Sandhills', nameTransliteration: 'Al-Ahqaf', numberOfAyahs: 35, revelationType: 'Meccan', ayahs: []),
      SurahModel(number: 47, nameArabic: 'محمد', nameEnglish: 'Muhammad', nameTransliteration: 'Muhammad', numberOfAyahs: 38, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 48, nameArabic: 'الفتح', nameEnglish: 'The Victory', nameTransliteration: 'Al-Fath', numberOfAyahs: 29, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 49, nameArabic: 'الحجرات', nameEnglish: 'The Rooms', nameTransliteration: 'Al-Hujurat', numberOfAyahs: 18, revelationType: 'Medinan', ayahs: []),
      SurahModel(number: 50, nameArabic: 'ق', nameEnglish: 'The Letter Qaf', nameTransliteration: 'Qaf', numberOfAyahs: 45, revelationType: 'Meccan', ayahs: []),
    ];
  }

  /// Get Surah by number
  SurahModel? getSurahByNumber(int number) {
    final surahs = getAvailableSurahs();
    try {
      return surahs.firstWhere((surah) => surah.number == number);
    } catch (e) {
      return null;
    }
  }

  /// Fetch complete Surah with all Ayahs from API
  Future<SurahModel?> fetchSurahWithAyahs(int surahNumber) async {
    try {
      // Get basic surah info
      final surahInfo = getSurahByNumber(surahNumber);
      if (surahInfo == null) return null;

      // Fetch Arabic text
      final arabicResponse = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber'),
      );

      // Fetch English translation
      final englishResponse = await http.get(
        Uri.parse('$_baseUrl/surah/$surahNumber/en.sahih'),
      );

      if (arabicResponse.statusCode == 200 && englishResponse.statusCode == 200) {
        final arabicData = jsonDecode(arabicResponse.body);
        final englishData = jsonDecode(englishResponse.body);

        final arabicAyahs = arabicData['data']['ayahs'] as List;
        final englishAyahs = englishData['data']['ayahs'] as List;

        List<AyahModel> ayahs = [];
        for (int i = 0; i < arabicAyahs.length; i++) {
          ayahs.add(AyahModel(
            number: arabicAyahs[i]['number'],
            numberInSurah: arabicAyahs[i]['numberInSurah'],
            textArabic: arabicAyahs[i]['text'],
            textEnglish: englishAyahs[i]['text'],
          ));
        }

        return SurahModel(
          number: surahInfo.number,
          nameArabic: surahInfo.nameArabic,
          nameEnglish: surahInfo.nameEnglish,
          nameTransliteration: surahInfo.nameTransliteration,
          numberOfAyahs: surahInfo.numberOfAyahs,
          revelationType: surahInfo.revelationType,
          ayahs: ayahs,
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error fetching Surah: $e');
      return null;
    }
  }
}
