import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<CartProvider>().orders;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Orders 📦',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📦', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your samosa journey\nstarts with your first order 🥟',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textLight),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(order.statusEmoji, style: const TextStyle(fontSize: 18)),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${order.id}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                    Text(
                                      _formatDate(order.createdAt),
                                      style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textLight),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _statusBadge(order.status),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(color: AppTheme.divider),
                        const SizedBox(height: 12),

                        // Items preview with real images
                        Column(
                          children: order.items.take(3).map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                        item.imageAsset,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFFFFF3E0),
                                          child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 16))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.quantity}× ${item.name}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textDark,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (item.extraChutneyName != null)
                                          Text(
                                            '+ ${item.extraChutneyName}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.total.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        if (order.items.length > 3)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '+ ${order.items.length - 3} more items',
                              style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textLight),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.fold(0, (s, i) => s + i.quantity)} total samosas',
                              style: GoogleFonts.poppins(fontSize: 11.5, color: AppTheme.textLight),
                            ),
                            Text(
                              'Total: ₹${order.total.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Track Button
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: const BorderSide(color: AppTheme.primary),
                                ),
                                child: Text(
                                  order.status == OrderStatus.delivered ? '🎉 View Details' : '🛵 Track Order',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Reorder
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                ),
                                child: Text(
                                  '🔄 Reorder',
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month) {
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final ampm = date.hour >= 12 ? 'PM' : 'AM';
      return 'Today at $hour:${date.minute.toString().padLeft(2, '0')} $ampm';
    }
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _statusBadge(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.confirmed:
        color = Colors.blue;
        break;
      case OrderStatus.preparing:
        color = AppTheme.warning;
        break;
      case OrderStatus.readyForPickup:
        color = Colors.purple;
        break;
      case OrderStatus.outForDelivery:
        color = AppTheme.primary;
        break;
      case OrderStatus.delivered:
        color = AppTheme.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        _statusText(status),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  String _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.readyForPickup:
        return 'Ready';
      case OrderStatus.outForDelivery:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}
