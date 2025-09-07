import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'news_screen.dart';
import 'reels_screen.dart';
import 'explore_screen.dart';
import 'games_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const NewsScreen(),
    const ReelsScreen(),
    const ExploreScreen(),
    const GamesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.8, -0.1),
            radius: 2.0,
            colors: [
              Color.fromRGBO(91, 157, 255, 0.18),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.2, 1.1),
              radius: 1.5,
              colors: [
                Color.fromRGBO(139, 91, 255, 0.12),
                Colors.transparent,
              ],
            ),
          ),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 68,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF131A26).withOpacity(0.9),
        buttonBackgroundColor: const Color(0xFF5B9DFF),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home_rounded, size: 28, color: Colors.white),
          Icon(Icons.play_circle_filled_rounded, size: 28, color: Colors.white),
          Icon(Icons.explore_rounded, size: 28, color: Colors.white),
          Icon(Icons.games_rounded, size: 28, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
