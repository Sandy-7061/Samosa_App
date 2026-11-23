import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import 'order_confirmation_screen.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _scheduleDelivery = false;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;
  String _addressType = 'Home';

  @override
  void dispose() {
    _addressController.dispose();
    _landmarkController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _selectedDate = date);
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
          'Checkout 📋',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Step 1: Delivery Details
            _sectionHeader('👤 Delivery Details', '1'),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Your full name',
              icon: Icons.person_outline,
              validator: (v) => v!.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v!.trim().isEmpty) return 'Phone is required';
                if (v.trim().length < 10) return 'Enter valid phone number';
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Step 2: Delivery Address
            _sectionHeader('📍 Delivery Address', '2'),
            const SizedBox(height: 12),

            // Address Type Chips
            Row(
              children: ['Home', 'Work', 'Other'].map((type) {
                final selected = _addressType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _addressType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppTheme.primary : AppTheme.divider,
                          width: 1.5,
                        ),
                        boxShadow: selected
                            ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8)]
                            : null,
                      ),
                      child: Text(
                        type,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppTheme.textMedium,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _addressController,
              label: 'Full Address',
              hint: 'House no., Street, Area, City',
              icon: Icons.location_on_outlined,
              maxLines: 3,
              validator: (v) => v!.trim().isEmpty ? 'Address is required' : null,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _landmarkController,
              label: 'Landmark (optional)',
              hint: 'Near school, temple, etc.',
              icon: Icons.map_outlined,
            ),

            const SizedBox(height: 20),

            // Step 3: Schedule
            _sectionHeader('⏰ Delivery Time', '3'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🚀', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deliver ASAP',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                '~30-40 min',
                                style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: !_scheduleDelivery,
                        onChanged: (v) => setState(() => _scheduleDelivery = !v),
                        activeColor: AppTheme.primary,
                      ),
                    ],
                  ),
                  if (!_scheduleDelivery) ...[
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('📅', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text(
                              'Schedule for Later',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _scheduleDelivery,
                          onChanged: (v) => setState(() => _scheduleDelivery = v),
                          activeColor: AppTheme.primary,
                        ),
                      ],
                    ),
                  ],
                  if (_scheduleDelivery) ...[
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textLight),
                                  ),
                                  Text(
                                    _selectedDate == null
                                        ? 'Pick a date'
                                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickTime,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: GoogleFonts.poppins(fontSize: 11, color: AppTheme.textLight),
                                  ),
                                  Text(
                                    _selectedTime == null
                                        ? 'Pick a time'
                                        : _selectedTime!.format(context),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Summary
            _sectionHeader('🧾 Order Summary', '4'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12)],
              ),
              child: Column(
                children: [
                  ...cart.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 36,
                                height: 36,
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
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.name} × ${item.quantity}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.extraChutneyName != null)
                                    Text(
                                      '+ ${item.extraChutneyName}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${item.total.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Delivery', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textLight)),
                    Text('₹${cart.deliveryFee.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  ]),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('GST (5%)', style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textLight)),
                    Text('₹${cart.tax.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
                  ]),
                  const Divider(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                    Text('₹${cart.total.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String? scheduledTime;
                    if (_scheduleDelivery && _selectedDate != null && _selectedTime != null) {
                      scheduledTime =
                          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.format(context)}';
                    }

                    final address =
                        '$_addressType: ${_addressController.text.trim()}${_landmarkController.text.trim().isNotEmpty ? ', Near ${_landmarkController.text.trim()}' : ''}';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          address: address,
                          scheduledTime: scheduledTime,
                          name: _nameController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                ),
                child: Text(
                  '💳  Proceed to Payment  •  ₹${cart.total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String step) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textLight),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppTheme.textLight),
      ),
    );
  }
}
