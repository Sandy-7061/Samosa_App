import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'order_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String address;
  final String? scheduledTime;
  final String name;

  const PaymentScreen({
    super.key,
    required this.address,
    this.scheduledTime,
    required this.name,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPayment = 'UPI';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'UPI',
      'name': 'UPI Payment',
      'subtitle': 'GPay, PhonePe, Paytm',
      'icon': '📱',
      'color': const Color(0xFF4285F4),
    },
    {
      'id': 'Card',
      'name': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': '💳',
      'color': const Color(0xFF6C63FF),
    },
    {
      'id': 'NetBanking',
      'name': 'Net Banking',
      'subtitle': 'All major banks',
      'icon': '🏦',
      'color': const Color(0xFF2196F3),
    },
    {
      'id': 'COD',
      'name': 'Cash on Delivery',
      'subtitle': 'Pay when delivered',
      'icon': '💰',
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': 'Wallet',
      'name': 'Samosa Wallet',
      'subtitle': 'Balance: ₹0.00',
      'icon': '👛',
      'color': AppTheme.primary,
    },
  ];

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final cart = context.read<CartProvider>();
    final order = cart.placeOrder(
      address: widget.address,
      scheduledTime: widget.scheduledTime,
      paymentMethod: _selectedPayment,
    );

    setState(() => _isProcessing = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(order: order, customerName: widget.name),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTheme.textDark),
            ),
          ),
        ),
        title: Text(
          'Payment 💳',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Amount Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Total Amount',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${cart.total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.address,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (widget.scheduledTime != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Scheduled: ${widget.scheduledTime}',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Select Payment Method',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),

          ...(_paymentMethods.map((method) {
            final isSelected = _selectedPayment == method['id'];
            return GestureDetector(
              onTap: () => setState(() => _selectedPayment = method['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? AppTheme.primary.withOpacity(0.15) : Colors.black.withOpacity(0.04),
                      blurRadius: isSelected ? 12 : 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: (method['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(method['icon'] as String, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            method['subtitle'] as String,
                            style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textLight),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.divider,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          })),

          const SizedBox(height: 16),

          // Security Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: AppTheme.success, size: 18),
                const SizedBox(width: 8),
                Text(
                  '100% Secure & Encrypted Payment',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      '🔐  Pay ₹${cart.total.toStringAsFixed(0)}  via $_selectedPayment',
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
