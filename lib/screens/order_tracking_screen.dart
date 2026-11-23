import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late Order _order;

  final List<Map<String, dynamic>> _steps = [
    {
      'status': OrderStatus.confirmed,
      'title': 'Order Confirmed',
      'subtitle': 'Kitchen received your samosa order',
      'svg': 'assets/svg/samosa.svg',
    },
    {
      'status': OrderStatus.preparing,
      'title': 'Fresh Frying in Kitchen',
      'subtitle': 'Master chef is golden-frying your samosas',
      'svg': 'assets/svg/flame.svg',
    },
    {
      'status': OrderStatus.outForDelivery,
      'title': 'Rider On The Way',
      'subtitle': 'Hot samosas packed in insulated heat box',
      'svg': 'assets/svg/scooter.svg',
    },
    {
      'status': OrderStatus.delivered,
      'title': 'Delivered Hot & Crispy',
      'subtitle': 'Enjoy your samosas with freshly dipped chutney!',
      'svg': 'assets/svg/chutney.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startListening();
  }

  void _startListening() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {});
      _startListening();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  int get _currentStepIndex {
    switch (_order.status) {
      case OrderStatus.confirmed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.readyForPickup:
        return 2;
      case OrderStatus.outForDelivery:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Track Samosa Order',
          style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w800, color: AppTheme.textDark),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ORDER #${_order.id}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _order.statusText,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _order.status == OrderStatus.delivered
                            ? 'Delivered fresh to your doorstep'
                            : 'Hot samosas on their way!',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                ScaleTransition(
                  scale: _order.status != OrderStatus.delivered ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      _steps[_currentStepIndex]['svg'] as String,
                    ),
                  ),
                ),
                if (_order.status != OrderStatus.delivered) ...[
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ETA',
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                      ),
                      Text(
                        '${_order.estimatedMinutes} min',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Progress Timeline
          Text(
            'Live Order Timeline',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 16)],
            ),
            child: Column(
              children: List.generate(_steps.length, (index) {
                final step = _steps[index];
                final isCompleted = index < _currentStepIndex;
                final isActive = index == _currentStepIndex;
                final isLast = index == _steps.length - 1;

                return TimelineTile(
                  isFirst: index == 0,
                  isLast: isLast,
                  axis: TimelineAxis.vertical,
                  alignment: TimelineAlign.start,
                  indicatorStyle: IndicatorStyle(
                    width: 44,
                    height: 44,
                    indicator: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? (isActive ? AppTheme.primary : AppTheme.accent)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 10)]
                            : null,
                      ),
                      child: SvgPicture.asset(
                        step['svg'] as String,
                        colorFilter: ColorFilter.mode(
                          isCompleted || isActive ? Colors.white : Colors.grey.shade400,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  beforeLineStyle: LineStyle(
                    color: index <= _currentStepIndex ? AppTheme.primary : AppTheme.divider,
                    thickness: 2.5,
                  ),
                  afterLineStyle: LineStyle(
                    color: index < _currentStepIndex ? AppTheme.primary : AppTheme.divider,
                    thickness: 2.5,
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isActive ? AppTheme.primary : (isCompleted ? AppTheme.textDark : AppTheme.textLight),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['subtitle'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: isActive || isCompleted ? AppTheme.textMedium : AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // Items in this order (Real photos + chutney add-ons)
          Text(
            'Items in Order',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12)],
            ),
            child: Column(
              children: [
                ..._order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset(
                                item.imageAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFFFF3E0),
                                  child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 22))),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                if (item.extraChutneyName != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '+ ${item.extraChutneyName}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                                Text(
                                  'Qty: ${item.quantity} × ₹${item.unitPrice.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textLight),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${item.total.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    )),
                const Divider(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Paid', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(
                      '₹${_order.total.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Delivery Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address & Info',
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                ),
                const SizedBox(height: 12),
                _detailRow(Icons.location_on_outlined, 'Address', _order.address),
                if (_order.scheduledTime != null) ...[
                  const SizedBox(height: 8),
                  _detailRow(Icons.access_time, 'Scheduled for', _order.scheduledTime!),
                ],
                const SizedBox(height: 8),
                _detailRow(Icons.payment_outlined, 'Payment', _order.paymentMethod),
              ],
            ),
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textLight),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
