import 'package:flutter/material.dart';

class ExtraChutney {
  final String id;
  final String name;
  final double price;
  final String imageAsset;
  final String description;
  final String badge;

  const ExtraChutney({
    required this.id,
    required this.name,
    required this.price,
    required this.imageAsset,
    required this.description,
    this.badge = '',
  });
}

final List<ExtraChutney> availableChutneys = [
  const ExtraChutney(
    id: 'hari_chutney',
    name: 'Extra Mint Hari Chutney',
    price: 10.0,
    imageAsset: 'assets/images/Hari_chatni.jpeg',
    description: 'Fresh spicy mint & coriander chutney with green chillies & roasted cumin',
    badge: '🌿 Spicy Dip',
  ),
  const ExtraChutney(
    id: 'tomato_chutney',
    name: 'Extra Tangy Sweet Chutney',
    price: 10.0,
    imageAsset: 'assets/images/Tomato_Chatni.jpeg',
    description: 'Sweet, tangy tamarind & tomato chutney infused with aromatic saunf',
    badge: '🍅 Sweet & Tangy',
  ),
  const ExtraChutney(
    id: 'both_chutney',
    name: 'Double Chutney Combo (Both)',
    price: 18.0,
    imageAsset: 'assets/images/Golden Samosas with Chutneys.png',
    description: 'Both Mint Hari & Sweet Chutneys (Save ₹2 on pair!)',
    badge: '⭐ Best Value',
  ),
];

class SamosaItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageEmoji;
  final String imageAsset;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isBestseller;
  final bool isSpicy;
  final List<String> ingredients;
  final String size;
  final int calories;

  const SamosaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageEmoji,
    required this.imageAsset,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.isBestseller,
    required this.isSpicy,
    required this.ingredients,
    required this.size,
    required this.calories,
  });
}

final List<SamosaItem> samosaMenu = [
  const SamosaItem(
    id: '1',
    name: 'Classic Aloo Samosa',
    description: 'Our signature crispy golden pastry stuffed with fragrant cumin spiced potatoes, tender green peas, and hand-ground spices. The timeless Indian street food icon!',
    price: 29.0,
    imageEmoji: '🥟',
    imageAsset: 'assets/images/Crispy Samosa.png',
    category: 'Classic',
    rating: 4.9,
    reviewCount: 2847,
    isBestseller: true,
    isSpicy: false,
    ingredients: ['Potatoes', 'Green Peas', 'Roasted Cumin', 'Coriander Seeds', 'Garam Masala', 'Crispy Ajwain Pastry'],
    size: 'Standard (1 pc)',
    calories: 250,
  ),
  const SamosaItem(
    id: '2',
    name: 'Spicy Keema Samosa',
    description: 'Slow-simmered minced lamb tossed with fiery green chillies, ginger, toasted coriander, and aromatic spices inside a flaky artisan crust.',
    price: 45.0,
    imageEmoji: '🔥',
    imageAsset: 'assets/images/samosa_keema.jpg',
    category: 'Premium',
    rating: 4.8,
    reviewCount: 1923,
    isBestseller: true,
    isSpicy: true,
    ingredients: ['Minced Lamb (Keema)', 'Onions', 'Green Chilli', 'Ginger Garlic', 'Kashmiri Lal Mirch', 'Crispy Crust'],
    size: 'Large (1 pc)',
    calories: 380,
  ),
  const SamosaItem(
    id: '3',
    name: 'Paneer Tikka Samosa',
    description: 'Creamy fresh cottage cheese cubes tossed in tandoori spices, smoked bell peppers, and herbs encased in a delightfully crunchy golden shell.',
    price: 42.0,
    imageEmoji: '🧀',
    imageAsset: 'assets/images/samosa_paneer.jpg',
    category: 'Premium',
    rating: 4.7,
    reviewCount: 1456,
    isBestseller: false,
    isSpicy: false,
    ingredients: ['Fresh Malai Paneer', 'Bell Peppers', 'Tandoori Marinade', 'Kasuri Methi', 'Cardamom', 'Golden Crust'],
    size: 'Large (1 pc)',
    calories: 310,
  ),
  const SamosaItem(
    id: '4',
    name: 'Schezwan Veggie Samosa',
    description: 'Fiery Indo-Chinese fusion samosa packed with wok-tossed crunchy cabbage, bell peppers, spring onions, and sizzling schezwan chili sauce.',
    price: 35.0,
    imageEmoji: '🌶️',
    imageAsset: 'assets/images/samosa_schezwan.jpg',
    category: 'Fusion',
    rating: 4.6,
    reviewCount: 987,
    isBestseller: false,
    isSpicy: true,
    ingredients: ['Crisp Vegetables', 'Fiery Schezwan Sauce', 'Spring Onions', 'Garlic', 'Toasted Sesame', 'Crunchy Crust'],
    size: 'Medium (1 pc)',
    calories: 220,
  ),
  const SamosaItem(
    id: '5',
    name: 'Punjabi Shahi Masala Samosa',
    description: 'Rich royal Punjabi style samosa stuffed with spicy spiced potatoes, toasted cashews, raisins, pomegranate anardana, and fragrant whole spices.',
    price: 39.0,
    imageEmoji: '👑',
    imageAsset: 'assets/images/Golden Samosas with Chutneys.png',
    category: 'Classic',
    rating: 4.9,
    reviewCount: 1840,
    isBestseller: true,
    isSpicy: false,
    ingredients: ['Spiced Potatoes', 'Roasted Kaju (Cashews)', 'Kishmish', 'Anardana (Pomegranate)', 'Amchur', 'Crispy Shell'],
    size: 'King Size (1 pc)',
    calories: 290,
  ),
  const SamosaItem(
    id: '6',
    name: 'Mini Samosa Party Platter',
    description: 'A lavish sharing platter of 6 hot bite-sized samosas served with extra dips — 2 Classic Aloo, 2 Paneer Tikka, and 2 Punjabi Masala samosas.',
    price: 99.0,
    imageEmoji: '🎉',
    imageAsset: 'assets/images/samosa_platter.jpg',
    category: 'Party Pack',
    rating: 4.9,
    reviewCount: 3201,
    isBestseller: true,
    isSpicy: false,
    ingredients: ['Assorted Fillings', 'Mini Golden Crusts', 'Complimentary Mint Dip', 'Complimentary Sweet Tamarind Dip'],
    size: 'Party Pack (6 pcs)',
    calories: 480,
  ),
];
