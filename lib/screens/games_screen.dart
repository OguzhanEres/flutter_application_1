import 'package:flutter/material.dart';
import '../widgets/game_card.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String selectedGame = 'catcher';
  int score = 0;
  int timeElapsed = 0;
  bool isGameRunning = false;

  final List<Map<String, dynamic>> games = [
    {
      'id': 'catcher',
      'title': 'Başlık Yakala',
      'description': 'Doğru anahtar kelimeleri yakala, yanlışlardan kaç',
      'icon': Icons.sports_baseball_rounded,
      'color': Colors.blue,
    },
    {
      'id': 'memory',
      'title': 'Haber Eşleştir',
      'description': 'Aynı haber konularını eşleştir',
      'icon': Icons.psychology_rounded,
      'color': Colors.purple,
    },
    {
      'id': 'reveal',
      'title': 'Kaydır Aç',
      'description': 'Doğru ritimde kaydırarak haberi aç',
      'icon': Icons.swipe_rounded,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.games_rounded,
                    size: 24,
                    color: Color(0xFF5B9DFF),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Oyunlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5B9DFF), Color(0xFF8B5BFF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Puan: $score',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Game Selection
            Container(
              height: 100, // Yüksekliği azalttık
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  final isSelected = selectedGame == game['id'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGame = game['id'];
                      });
                    },
                    child: Container(
                      width: 180, // Genişliği azalttık
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12), // Padding'i azalttık
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  game['color'].withOpacity(0.3),
                                  game['color'].withOpacity(0.1),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.04),
                                  Colors.white.withOpacity(0.02),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? game['color']
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Eklendi
                        children: [
                          Icon(
                            game['icon'],
                            size: 24, // Icon boyutunu azalttık
                            color: isSelected ? game['color'] : Colors.grey,
                          ),
                          const SizedBox(height: 6), // Azaltıldı
                          Text(
                            game['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Font boyutunu azalttık
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                            maxLines: 1, // Tek satır
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2), // Azaltıldı
                          Flexible( // Expanded yerine Flexible
                            child: Text(
                              game['description'],
                              style: TextStyle(
                                fontSize: 10, // Font boyutunu azalttık
                                color: Colors.grey.shade400,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Game Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16), // Padding azaltıldı
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: _buildGameContent(),
              ),
            ),

            // Bottom Controls
            Container(
              padding: const EdgeInsets.all(12), // Padding azaltıldı
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isGameRunning ? null : _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9DFF),
                        padding: const EdgeInsets.symmetric(vertical: 12), // Padding azaltıldı
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isGameRunning ? 'Oyun Devam Ediyor...' : 'Oyunu Başlat',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Font boyutu azaltıldı
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, // Padding azaltıldı
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatTime(timeElapsed),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Font boyutu azaltıldı
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    switch (selectedGame) {
      case 'catcher':
        return _buildCatcherGame();
      case 'memory':
        return _buildMemoryGame();
      case 'reveal':
        return _buildRevealGame();
      default:
        return const Center(
          child: Text('Oyun seçin'),
        );
    }
  }

  Widget _buildCatcherGame() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Başlık Yakala',
          style: TextStyle(
            fontSize: 20, // Font boyutu azaltıldı
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6), // Azaltıldı
        Text(
          'Sol/sağ ok tuşları ile hareket edin. Yeşil kelimeleri yakalayın, kırmızılardan kaçın.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12, // Font boyutu azaltıldı
          ),
        ),
        const SizedBox(height: 12), // Azaltıldı
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_baseball_rounded,
                    size: 48, // Icon boyutu azaltıldı
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Oyun alanı hazırlanıyor...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryGame() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Haber Eşleştir',
          style: TextStyle(
            fontSize: 20, // Font boyutu azaltıldı
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6), // Azaltıldı
        Text(
          'Aynı haber anahtar kelimelerini eşleştirin. Tüm çiftleri bulun.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12, // Font boyutu azaltıldı
          ),
        ),
        const SizedBox(height: 12), // Azaltıldı
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 6, // Azaltıldı
              mainAxisSpacing: 6, // Azaltıldı
              childAspectRatio: 1,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                      fontSize: 20, // Font boyutu azaltıldı
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRevealGame() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kaydır Aç',
          style: TextStyle(
            fontSize: 20, // Font boyutu azaltıldı
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6), // Azaltıldı
        Text(
          'Sabit ritimde kaydırarak haberin tamamını açın.',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12, // Font boyutu azaltıldı
          ),
        ),
        const SizedBox(height: 12), // Azaltıldı
        Expanded(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12), // Padding azaltıldı
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teknoloji sektörüne yeni yatırım',
                      style: TextStyle(
                        fontSize: 16, // Font boyutu azaltıldı
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6), // Azaltıldı
                    Text(
                      'Kaydırma ritmi doğru olursa paragraf açılır.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12, // Font boyutu azaltıldı
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12), // Azaltıldı
              Container(
                padding: const EdgeInsets.all(12), // Padding azaltıldı
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Kaydırma Kontrolü',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Font boyutu azaltıldı
                      ),
                    ),
                    const SizedBox(height: 8), // Azaltıldı
                    Slider(
                      value: 0,
                      onChanged: (value) {},
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startGame() {
    setState(() {
      isGameRunning = true;
      score = 0;
      timeElapsed = 0;
    });

    // Simulate game logic
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isGameRunning = false;
        score = 50; // Mock score
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
