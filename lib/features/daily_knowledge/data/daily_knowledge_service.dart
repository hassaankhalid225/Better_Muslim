import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/models.dart';

class DailyKnowledgeService {
  Future<List<Ayah>> getDailyAyahs({int count = 3}) async {
    final String response = await rootBundle.loadString('assets/data/ayahs.json');
    final List<dynamic> data = json.decode(response);
    final List<Ayah> ayahs = data.map((json) => Ayah.fromJson(json)).toList();
    
    if (ayahs.isEmpty) {
      throw Exception('No Ayahs found');
    }

    // Get current day of year
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStart = now.difference(startOfYear).inDays;
    
    // Return 2-3 ayat starting from the day's index
    final startIndex = daysSinceStart % ayahs.length;
    final List<Ayah> dailyAyahs = [];
    
    for (int i = 0; i < count && i < ayahs.length; i++) {
      final index = (startIndex + i) % ayahs.length;
      dailyAyahs.add(ayahs[index]);
    }
    
    return dailyAyahs;
  }

  Future<List<Hadith>> getDailyHadiths({int count = 3}) async {
    final String response = await rootBundle.loadString('assets/data/hadiths.json');
    final List<dynamic> data = json.decode(response);
    final List<Hadith> hadiths = data.map((json) => Hadith.fromJson(json)).toList();
    
    if (hadiths.isEmpty) {
      throw Exception('No Hadiths found');
    }

    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceStart = now.difference(startOfYear).inDays;
    
    // Return 2-3 hadith starting from the day's index
    final startIndex = daysSinceStart % hadiths.length;
    final List<Hadith> dailyHadiths = [];
    
    for (int i = 0; i < count && i < hadiths.length; i++) {
      final index = (startIndex + i) % hadiths.length;
      dailyHadiths.add(hadiths[index]);
    }
    
    return dailyHadiths;
  }
}
