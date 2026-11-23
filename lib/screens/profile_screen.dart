import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16),
                          ],
                        ),
                        child: const Center(
                          child: Text('🙂', style: TextStyle(fontSize: 42)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Samosa Lover 🥟',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '+91 98765 43210',
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Stats
                  Row(
                    children: [
                      _statCard('🥟', '24', 'Samosas\nOrdered'),
                      const SizedBox(width: 12),
                      _statCard('⭐', '4.9', 'Avg\nRating'),
                      const SizedBox(width: 12),
                      _statCard('💰', '₹892', 'Total\nSaved'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Menu
                  _menuSection('Account', [
                    _menuItem(Icons.person_outline, 'Edit Profile', () {}),
                    _menuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
                    _menuItem(Icons.payment_outlined, 'Payment Methods', () {}),
                  ]),

                  const SizedBox(height: 12),

                  _menuSection('Preferences', [
                    _menuItem(Icons.notifications_outlined, 'Notifications', () {}),
                    _menuItem(Icons.language_outlined, 'Language', () {}),
                  ]),

                  const SizedBox(height: 12),

                  _menuSection('About', [
                    _menuItem(Icons.star_outline_rounded, 'Rate Us', () {}),
                    _menuItem(Icons.share_outlined, 'Share App', () {}),
                    _menuItem(Icons.help_outline, 'Help & Support', () {}),
                    _menuItem(Icons.info_outline, 'About Samosa House', () {}),
                  ]),

                  const SizedBox(height: 12),

                  // Logout
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.08),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.logout, color: AppTheme.error, size: 20),
                      ),
                      title: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.error,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Text(
                    '🥟 Samosa House v1.0.0',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textLight),
                  ),
                  Text(
                    'Made with ❤️ in India',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.08), blurRadius: 12)],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 10, color: AppTheme.textLight, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textLight,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.08),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textDark),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
      onTap: onTap,
    );
  }
}
