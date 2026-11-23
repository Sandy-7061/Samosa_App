enum OrderStatus {
  confirmed,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
}

class OrderItem {
  final String samosaId;
  final String name;
  final double price;
  final int quantity;
  final String emoji;
  final String imageAsset;
  final String? extraChutneyName;
  final double extraChutneyPrice;

  OrderItem({
    required this.samosaId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.emoji,
    this.imageAsset = 'assets/images/Crispy Samosa.png',
    this.extraChutneyName,
    this.extraChutneyPrice = 0.0,
  });

  double get unitPrice => price + extraChutneyPrice;
  double get total => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
        'samosaId': samosaId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'emoji': emoji,
        'imageAsset': imageAsset,
        'extraChutneyName': extraChutneyName,
        'extraChutneyPrice': extraChutneyPrice,
      };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        samosaId: map['samosaId'],
        name: map['name'],
        price: map['price'].toDouble(),
        quantity: map['quantity'],
        emoji: map['emoji'] ?? '🥟',
        imageAsset: map['imageAsset'] ?? 'assets/images/Crispy Samosa.png',
        extraChutneyName: map['extraChutneyName'],
        extraChutneyPrice: (map['extraChutneyPrice'] ?? 0.0).toDouble(),
      );
}

class Order {
  final String id;
  final List<OrderItem> items;
  final String address;
  final String? scheduledTime;
  final DateTime createdAt;
  OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final String paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.address,
    this.scheduledTime,
    required this.createdAt,
    this.status = OrderStatus.confirmed,
    required this.subtotal,
    this.deliveryFee = 25.0,
    required this.tax,
    required this.paymentMethod,
  });

  double get total => subtotal + deliveryFee + tax;

  String get statusText {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Fresh Samosas Frying';
      case OrderStatus.readyForPickup:
        return 'Packed & Fresh in Kitchen';
      case OrderStatus.outForDelivery:
        return 'Rider on the Way';
      case OrderStatus.delivered:
        return 'Delivered Hot & Crispy';
    }
  }

  String get statusEmoji {
    switch (status) {
      case OrderStatus.confirmed:
        return '✅';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.readyForPickup:
        return '📦';
      case OrderStatus.outForDelivery:
        return '🛵';
      case OrderStatus.delivered:
        return '🎉';
    }
  }

  int get estimatedMinutes {
    switch (status) {
      case OrderStatus.confirmed:
        return 30;
      case OrderStatus.preparing:
        return 20;
      case OrderStatus.readyForPickup:
        return 15;
      case OrderStatus.outForDelivery:
        return 8;
      case OrderStatus.delivered:
        return 0;
    }
  }
}

class CartItem {
  final String samosaId;
  final String name;
  final double price;
  int quantity;
  final String emoji;
  final String imageAsset;
  final String? extraChutneyId;
  final String? extraChutneyName;
  final double extraChutneyPrice;

  CartItem({
    required this.samosaId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.emoji,
    required this.imageAsset,
    this.extraChutneyId,
    this.extraChutneyName,
    this.extraChutneyPrice = 0.0,
  });

  // Unique key identifying samosa + chutney combination
  String get cartKey => '$samosaId-${extraChutneyId ?? "none"}';

  double get unitPrice => price + extraChutneyPrice;
  double get total => unitPrice * quantity;
}
