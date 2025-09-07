import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/news_model.dart';
import '../data/mock_data.dart';
import '../widgets/reel_overlay.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeControllers();
  }

  void _initializeControllers() async {
    List<VideoPlayerController> tempControllers = [];
    
    for (var news in MockData.reelsList) {
      if (news.videoUrl.isNotEmpty) {
        // Sadece video URL'i olan haberler için video controller oluştur
        try {
          final controller = VideoPlayerController.network(news.videoUrl);
          await controller.initialize();
          tempControllers.add(controller);
        } catch (e) {
          // Video yüklenemezse null ekle
          tempControllers.add(VideoPlayerController.network(''));
        }
      } else {
        // Görsel için null controller ekle
        tempControllers.add(VideoPlayerController.network(''));
      }
    }
    
    _controllers = tempControllers;
    
    // İlk video varsa oynat
    if (_controllers.isNotEmpty) {
      final firstNews = MockData.reelsList.first;
      if (firstNews.videoUrl.isNotEmpty && _controllers[0].value.isInitialized) {
        _controllers[0].play();
        _controllers[0].setLooping(true);
      }
    }
    
    if (mounted) {
      setState(() {
        // Controllers yüklendi
      });
    }
  }

  void _onPageChanged(int index) {
    if (_controllers.isNotEmpty) {
      // Tüm videoları duraklat
      for (int i = 0; i < _controllers.length; i++) {
        if (_controllers[i].value.isInitialized) {
          _controllers[i].pause();
        }
      }
      
      // Mevcut sayfadaki videoyu oynat (eğer video varsa)
      if (index < _controllers.length && 
          index < MockData.reelsList.length && 
          MockData.reelsList[index].videoUrl.isNotEmpty &&
          _controllers[index].value.isInitialized) {
        _controllers[index].play();
        _controllers[index].setLooping(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Veriler her zaman mevcut, controllers olmasa da göster
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: MockData.reelsList.length,
        itemBuilder: (context, index) {
          final news = MockData.reelsList[index];
          return _buildReelItem(news, index);
        },
      ),
    );
  }

  Widget _buildReelItem(NewsModel news, int index) {
    return Stack(
      children: [
        // Video Background veya Görsel
        if (news.videoUrl.isNotEmpty && index < _controllers.length)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controllers[index].value.size.width,
                height: _controllers[index].value.size.height,
                child: VideoPlayer(_controllers[index]),
              ),
            ),
          )
        else
          // Görsel gösterimi (video URL'i boş ise)
          SizedBox.expand(
            child: news.imageUrl.startsWith('assets/')
                ? news.imageUrl.contains('teknofest_yarismalar')
                    ? Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF0A1628),
                              Color(0xFF1E3A5F),
                              Color(0xFF0A1628),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Teknoloji arkaplan efekti
                            Positioned.fill(
                              child: CustomPaint(
                                painter: TechBackgroundPainter(),
                              ),
                            ),
                            // Ana içerik
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // TEKNOFEST logosu yerine büyük başlık
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF00B4D8),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Column(
                                      children: [
                                        Text(
                                          'TEKNOFEST',
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 3,
                                          ),
                                        ),
                                        Text(
                                          'YARIŞMALARI',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF00B4D8),
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // Alt metin
                                  const Text(
                                    'Kritik Alanlarda Teknolojik\nGelişim Destekleniyor',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Teknoloji ikonları
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildTechIcon(Icons.memory, 'AI'),
                                      _buildTechIcon(Icons.precision_manufacturing, 'Robotik'),
                                      _buildTechIcon(Icons.flight, 'Drone'),
                                      _buildTechIcon(Icons.rocket_launch, 'Uzay'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: const Color(0xFF0E1320),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.festival,
                                size: 120,
                                color: Color(0xFFFF6B35),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'TEKNOFEST 2024',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Türkiye\'nin En Büyük Teknoloji Festivali',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '🚀 KATIL!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : CachedNetworkImage(
                    imageUrl: news.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF0E1320),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF0E1320),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
          ),

        // Dark overlay for better text visibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Location Map (top-left) - İsimsiz harita
        Positioned(
          top: 60,
          left: 16,
          child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: LatLng(news.latitude, news.longitude),
                      zoom: 8,
                      interactiveFlags: InteractiveFlag.none, // Harita etkileşimsiz
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(news.latitude, news.longitude),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF6B35).withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Harita üzerine konum bilgisi (şehir ismi olmadan)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFFF6B35),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Konumda',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Title Suggestion Button (top-right)
        Positioned(
          top: 60,
          right: 16,
          child: GestureDetector(
            onTap: () => _showTitleSuggestions(context, news),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Başlık Öner',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content Overlay (bottom)
        ReelOverlay(news: news),
      ],
    );
  }

  void _showTitleSuggestions(BuildContext context, NewsModel news) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A), // Transparan olmayan arka plan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A), // Koyu gri, opak
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00B4D8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B4D8).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lightbulb,
                      color: Color(0xFF00B4D8),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Başlık Önerileri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00B4D8).withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mevcut Başlık:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'TEKNOFEST YARIŞMALARI - Kritik Alanlarda Teknolojik Gelişim',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'AI Önerileri:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00B4D8),
                ),
              ),
              const SizedBox(height: 12),
              _buildSuggestionItem('🚀 Geleceğin Teknolojilerinde Türkiye Öncü', 156, true),
              _buildSuggestionItem('🤖 TEKNOFEST\'te Yapay Zeka Devrimi', 132, false),
              _buildSuggestionItem('🛸 Drone Yarışlarında Rekor Katılım', 98, false),
              _buildSuggestionItem('⚡ Robotik Alanda Çığır Açan Projeler', 87, false),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00B4D8).withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Kendi başlık önerinizi yazın...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Color(0xFF00B4D8),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Kapat',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B4D8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Gönder',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String title, int votes, [bool isPopular = false]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPopular 
            ? const Color(0xFF00B4D8).withOpacity(0.1)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPopular 
              ? const Color(0xFF00B4D8)
              : Colors.white.withOpacity(0.1),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'POPÜLER',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (isPopular) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isPopular ? const Color(0xFF00B4D8) : Colors.white,
                fontWeight: isPopular ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$votes',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00B4D8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // Oy verme işlemi
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Oy Ver',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF00B4D8).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF00B4D8),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00B4D8),
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }
}

// Custom Painter for tech background
class TechBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00B4D8).withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Çizgi ağı çiz
    for (int i = 0; i < 20; i++) {
      double x = (size.width / 20) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (int i = 0; i < 30; i++) {
      double y = (size.height / 30) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Parlayan daireler ekle
    final circlePaint = Paint()
      ..color = const Color(0xFF00B4D8).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      20,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      15,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
