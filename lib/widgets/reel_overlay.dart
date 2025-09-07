import 'package:flutter/material.dart';
import '../models/news_model.dart';

class ReelOverlay extends StatefulWidget {
  final NewsModel news;

  const ReelOverlay({super.key, required this.news});

  @override
  State<ReelOverlay> createState() => _ReelOverlayState();
}

class _ReelOverlayState extends State<ReelOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isLiked = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.55),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.news.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.news.location,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getTimeAgo(widget.news.publishDate),
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.news.keywords.take(4).map((keyword) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: keyword == 'TEKNOFEST' 
                                    ? const Color(0xFFFF6B35).withOpacity(0.8)
                                    : const Color(0xFF5B9DFF).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: keyword == 'TEKNOFEST'
                                    ? Border.all(color: Colors.white.withOpacity(0.3))
                                    : null,
                              ),
                              child: Text(
                                '#$keyword',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: keyword == 'TEKNOFEST' 
                                      ? FontWeight.bold 
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Action Buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '${widget.news.likes}',
                  color: isLiked ? Colors.red : Colors.white,
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    if (isLiked) {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.comment_rounded,
                  label: '${widget.news.shares}',
                  color: Colors.white,
                  onTap: () {
                    // Show comments
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: Icons.share_rounded,
                  label: 'Paylaş',
                  color: Colors.white,
                  onTap: () {
                    // Share functionality
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  label: '',
                  color: isBookmarked ? const Color(0xFF5B9DFF) : Colors.white,
                  onTap: () {
                    setState(() {
                      isBookmarked = !isBookmarked;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: icon == Icons.favorite && isLiked
                      ? 1.0 + (_animationController.value * 0.3)
                      : 1.0,
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                );
              },
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime publishDate) {
    final now = DateTime.now();
    final difference = now.difference(publishDate);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}dk';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}sa';
    } else {
      return '${difference.inDays}g';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
