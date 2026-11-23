import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/samosa_item.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final SamosaItem samosa;
  const ItemDetailScreen({super.key, required this.samosa});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;
  ExtraChutney? _selectedChutney;

  double get _unitPrice => widget.samosa.price + (_selectedChutney?.price ?? 0.0);
  double get _totalPrice => _unitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Samosa Real Image Sliver App Bar
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: AppTheme.primary,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.textDark),
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20, color: AppTheme.primary),
                            if (cart.cartCount > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${cart.cartCount}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'samosa-img-${widget.samosa.id}',
                        child: Image.asset(
                          widget.samosa.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFFFF3E0),
                            child: Center(
                              child: Text(widget.samosa.imageEmoji, style: const TextStyle(fontSize: 80)),
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay for smooth contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      // Bottom curve overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Details Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges Row
                      Row(
                        children: [
                          // Veg / Non-Veg SVG Badge
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
                              ],
                            ),
                            child: widget.samosa.category == 'Premium' && widget.samosa.name.contains('Keema')
                                ? Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFD32F2F), width: 1.5),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: const Center(
                                      child: CircleAvatar(
                                        radius: 4.5,
                                        backgroundColor: Color(0xFFD32F2F),
                                      ),
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/svg/veg.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                          ),
                          const SizedBox(width: 8),

                          if (widget.samosa.isBestseller) ...[
                            _badge('★ Bestseller', AppTheme.primary),
                            const SizedBox(width: 8),
                          ],
                          if (widget.samosa.isSpicy) ...[
                            _spicyBadge(),
                            const SizedBox(width: 8),
                          ],
                          _badge(widget.samosa.category, const Color(0xFF8D6E63)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Name & Base Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.samosa.name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textDark,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${widget.samosa.price.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Text(
                                'per piece',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rating & Reviews
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < widget.samosa.rating.floor()
                                  ? Icons.star_rounded
                                  : (i < widget.samosa.rating
                                      ? Icons.star_half_rounded
                                      : Icons.star_border_rounded),
                              color: const Color(0xFFFFB300),
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.samosa.rating}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${widget.samosa.reviewCount} customer reviews)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        widget.samosa.description,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: AppTheme.textMedium,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Size and Calories Info
                      Row(
                        children: [
                          _infoChip(Icons.straighten_rounded, widget.samosa.size),
                          const SizedBox(width: 10),
                          _infoChip(Icons.local_fire_department_rounded, '${widget.samosa.calories} kcal'),
                          const SizedBox(width: 10),
                          _infoChip(Icons.timer_outlined, '15-20 min delivery'),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Complimentary Free Chutneys Notice
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFA5D6A7)),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/chutney.svg',
                              width: 28,
                              height: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complimentary Dips Included Free!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1B5E20),
                                    ),
                                  ),
                                  Text(
                                    '1x Mint Coriander + 1x Sweet Tamarind dip pouch included with every samosa.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // ============================================
                      // EXTRA CHUTNEY ADD-ON SECTION (USER REQUIREMENT)
                      // ============================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/chutney.svg',
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Want Extra Chutney?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Freshly churned in our kitchen daily',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'OPTIONAL ADD-ON',
                              style: GoogleFonts.poppins(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Option 0: No extra chutney
                      _buildChutneyOptionCard(
                        title: 'No Extra Chutney (Only Free Dips)',
                        subtitle: 'Stick with the complimentary dips included in box',
                        price: 0.0,
                        imageAsset: null,
                        isSelected: _selectedChutney == null,
                        onTap: () => setState(() => _selectedChutney = null),
                        badge: 'Default',
                      ),
                      const SizedBox(height: 10),

                      // Options 1, 2, 3 from availableChutneys
                      ...availableChutneys.map((chutney) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildChutneyOptionCard(
                            title: chutney.name,
                            subtitle: chutney.description,
                            price: chutney.price,
                            imageAsset: chutney.imageAsset,
                            isSelected: _selectedChutney?.id == chutney.id,
                            onTap: () => setState(() => _selectedChutney = chutney),
                            badge: chutney.badge,
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Ingredients
                      Text(
                        'Ingredients & Spices',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.samosa.ingredients
                            .map((ing) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppTheme.primary.withOpacity(0.2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    ing,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.textMedium,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Fixed Action Bar with Animated Add to Cart
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Quantity selector
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18, color: AppTheme.primary),
                            onPressed: _quantity > 1
                                ? () => setState(() => _quantity--)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '$_quantity',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18, color: AppTheme.primary),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Add to Cart Button with Dynamic Total Price
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartProvider>().addToCart(
                                widget.samosa,
                                chutney: _selectedChutney,
                                quantity: _quantity,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppTheme.accent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Added $_quantity x ${widget.samosa.name}${_selectedChutney != null ? " with ${_selectedChutney!.name}" : ""} to cart!',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5),
                                    ),
                                  ),
                                ],
                              ),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: const Color(0xFFFFEB3B),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CartScreen()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: AppTheme.primary.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Add to Cart  •  ₹${_totalPrice.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildChutneyOptionCard({
    required String title,
    required String subtitle,
    required double price,
    required String? imageAsset,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8F0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppTheme.primary.withOpacity(0.12) : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio Circle / Checkmark
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, size: 14, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Chutney Real Image Thumbnail (if available)
            if (imageAsset != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFFFF3E0),
                      child: const Center(child: Text('🥣', style: TextStyle(fontSize: 18))),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else ...[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('✓', style: TextStyle(fontSize: 20, color: Colors.grey))),
              ),
              const SizedBox(width: 12),
            ],

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppTheme.primary : AppTheme.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badge != null && badge.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.poppins(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppTheme.textMedium,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      color: AppTheme.textLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Price badge
            Text(
              price == 0.0 ? 'FREE' : '+₹${price.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: price == 0.0 ? const Color(0xFF2E7D32) : AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _spicyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/flame.svg',
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 3),
          Text(
            'Spicy',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC62828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
