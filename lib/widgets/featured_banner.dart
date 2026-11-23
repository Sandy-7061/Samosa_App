import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/samosa_item.dart';
import '../screens/item_detail_screen.dart';
import '../utils/app_theme.dart';

class FeaturedBanner extends StatefulWidget {
  const FeaturedBanner({super.key});

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'Crispy Golden Aloo',
      'subtitle': 'Fried fresh every 30 mins\nServed with mint & tamarind dips',
      'tag': 'HOT & CRISPY',
      'discount': 'FREE CHUTNEY',
      'gradientColors': [const Color(0xFFC83803), const Color(0xFFE8521A)],
      'imageAsset': 'assets/images/Crispy Samosa.png',
      'samosaId': '1',
    },
    {
      'title': 'Spicy Mutton Keema',
      'subtitle': 'Aromatic slow-cooked minced lamb\nin an artisan flaky crust',
      'tag': 'CHEF SPECIAL',
      'discount': 'FLAT ₹15 OFF',
      'gradientColors': [const Color(0xFF5A1408), const Color(0xFF8B1D0B)],
      'imageAsset': 'assets/images/samosa_keema.jpg',
      'samosaId': '2',
    },
    {
      'title': 'Mega Party Platter',
      'subtitle': '6 Assorted hot samosas\nPerfect for family & friends',
      'tag': 'PARTY PACK',
      'discount': 'SAVE ₹35',
      'gradientColors': [const Color(0xFFB25E00), const Color(0xFFE65100)],
      'imageAsset': 'assets/images/samosa_platter.jpg',
      'samosaId': '6',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final nextPage = (_currentPage + 1) % banners.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    final item = samosaMenu.firstWhere(
                      (s) => s.id == banner['samosaId'],
                      orElse: () => samosaMenu.first,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ItemDetailScreen(samosa: item)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: banner['gradientColors'] as List<Color>,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (banner['gradientColors'] as List<Color>)[0].withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative glowing circle
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),

                        // Real samosa photo thumbnail on right
                        Positioned(
                          right: 12,
                          bottom: 12,
                          top: 12,
                          width: 135,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    banner['imageAsset'] as String,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Left text content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 150, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Badge with SVG
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.22),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/samosa.svg',
                                              width: 12,
                                              height: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              banner['tag'] as String,
                                              style: GoogleFonts.poppins(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    banner['title'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    banner['subtitle'] as String,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),

                              // Bottom action button / tag
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      banner['discount'] as String,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 11,
                                      color: AppTheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentPage,
          count: banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3.5,
            activeDotColor: AppTheme.primary,
            dotColor: AppTheme.primary.withOpacity(0.2),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}
