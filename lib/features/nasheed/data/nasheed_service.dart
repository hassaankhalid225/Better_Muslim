import '../domain/models/nasheed_model.dart';

/// Nasheed Service
/// Provides Islamic nasheed/video data
class NasheedService {
  /// Get all nasheeds (20+ Islamic videos)
  List<NasheedModel> getAllNasheeds() {
    return [
      // 1
      const NasheedModel(
        id: '1',
        title: "Tala'al Badru 'Alayna",
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Orlbo9vJYmU',
        thumbnailUrl: 'https://img.youtube.com/vi/Orlbo9vJYmU/maxresdefault.jpg',
        duration: '4:23',
        views: 15000000,
      ),
      
      // 2
      const NasheedModel(
        id: '2',
        title: 'Asma Allah Al-Husna',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=gny_8Bc9kUE',
        thumbnailUrl: 'https://img.youtube.com/vi/gny_8Bc9kUE/maxresdefault.jpg',
        duration: '5:10',
        views: 28000000,
      ),
      
      // 3
      const NasheedModel(
        id: '3',
        title: 'Hasbi Rabbi',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=aQN_nZW3XBk',
        thumbnailUrl: 'https://img.youtube.com/vi/aQN_nZW3XBk/maxresdefault.jpg',
        duration: '3:54',
        views: 12000000,
      ),
      
      // 4
      const NasheedModel(
        id: '4',
        title: 'Ya Nabi Salam Alayka',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=WUQF0EeX60w',
        thumbnailUrl: 'https://img.youtube.com/vi/WUQF0EeX60w/maxresdefault.jpg',
        duration: '4:45',
        views: 45000000,
      ),
      
      // 5
      const NasheedModel(
        id: '5',
        title: 'Assalamu Alayka',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:12',
        views: 8500000,
      ),
      
      // 6
      const NasheedModel(
        id: '6',
        title: 'Rahman Ya Rahman',
        artist: 'Mesut Kurtis',
        youtubeUrl: 'https://www.youtube.com/watch?v=nqCZ5mXRiZg',
        thumbnailUrl: 'https://img.youtube.com/vi/nqCZ5mXRiZg/maxresdefault.jpg',
        duration: '4:30',
        views: 6200000,
      ),
      
      // 7
      const NasheedModel(
        id: '7',
        title: 'Insha Allah',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=4lqr1y0_5Rk',
        thumbnailUrl: 'https://img.youtube.com/vi/4lqr1y0_5Rk/maxresdefault.jpg',
        duration: '4:18',
        views: 95000000,
      ),
      
      // 8
      const NasheedModel(
        id: '8',
        title: 'Baraka Allahu Lakuma',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '3:45',
        views: 22000000,
      ),
      
      // 9
      const NasheedModel(
        id: '9',
        title: 'Mawlaya',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=eoP0NHsGJIo',
        thumbnailUrl: 'https://img.youtube.com/vi/eoP0NHsGJIo/maxresdefault.jpg',
        duration: '5:25',
        views: 18000000,
      ),
      
      // 10
      const NasheedModel(
        id: '10',
        title: 'Subhana Allah',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:05',
        views: 7800000,
      ),
      
      // 11
      const NasheedModel(
        id: '11',
        title: 'Allahu',
        artist: 'Labbayk',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '3:58',
        views: 5400000,
      ),
      
      // 12
      const NasheedModel(
        id: '12',
        title: 'My Ummah',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:42',
        views: 9200000,
      ),
      
      // 13
      const NasheedModel(
        id: '13',
        title: 'Ramadan',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:15',
        views: 42000000,
      ),
      
      // 14
      const NasheedModel(
        id: '14',
        title: 'Al-Muallim',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '5:18',
        views: 16000000,
      ),
      
      // 15
      const NasheedModel(
        id: '15',
        title: 'Number One For Me',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '3:52',
        views: 38000000,
      ),
      
      // 16
      const NasheedModel(
        id: '16',
        title: 'Make Me Strong',
        artist: 'Sami Yusuf',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:28',
        views: 11000000,
      ),
      
      // 17
      const NasheedModel(
        id: '17',
        title: 'For the Rest of My Life',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:35',
        views: 58000000,
      ),
      
      // 18
      const NasheedModel(
        id: '18',
        title: 'Forgive Me',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:08',
        views: 25000000,
      ),
      
      // 19
      const NasheedModel(
        id: '19',
        title: 'Wherever You Are',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:22',
        views: 72000000,
      ),
      
      // 20
      const NasheedModel(
        id: '20',
        title: 'Always Be There',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '3:48',
        views: 19000000,
      ),
      
      // 21
      const NasheedModel(
        id: '21',
        title: 'Thank You Allah',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:12',
        views: 34000000,
      ),
      
      // 22
      const NasheedModel(
        id: '22',
        title: 'The Chosen One',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:55',
        views: 28000000,
      ),
      
      // 23
      const NasheedModel(
        id: '23',
        title: 'Palestine Will Be Free',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:38',
        views: 15000000,
      ),
      
      // 24
      const NasheedModel(
        id: '24',
        title: 'Open Your Eyes',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '3:42',
        views: 21000000,
      ),
      
      // 25
      const NasheedModel(
        id: '25',
        title: 'One Big Family',
        artist: 'Maher Zain',
        youtubeUrl: 'https://www.youtube.com/watch?v=Tz-aNk-Hf_M',
        thumbnailUrl: 'https://img.youtube.com/vi/Tz-aNk-Hf_M/maxresdefault.jpg',
        duration: '4:28',
        views: 12000000,
      ),
    ];
  }

  /// Get paginated nasheeds
  List<NasheedModel> getPaginatedNasheeds(int page, int pageSize) {
    final allNasheeds = getAllNasheeds();
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, allNasheeds.length);
    
    if (startIndex >= allNasheeds.length) {
      return [];
    }
    
    return allNasheeds.sublist(startIndex, endIndex);
  }
}
