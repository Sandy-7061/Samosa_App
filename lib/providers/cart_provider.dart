import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/order_model.dart';
import '../models/samosa_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final List<Order> _orders = [];
  static const _uuid = Uuid();

  List<CartItem> get cartItems => _cartItems;
  List<Order> get orders => _orders;

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.total);

  double get tax => subtotal * 0.05; // 5% GST

  double get deliveryFee => subtotal > 0 ? 25.0 : 0.0;

  double get total => subtotal + tax + deliveryFee;

  void addToCart(
    SamosaItem samosa, {
    ExtraChutney? chutney,
    int quantity = 1,
  }) {
    final chutneyId = chutney?.id;
    final cartKey = '${samosa.id}-${chutneyId ?? "none"}';

    final index = _cartItems.indexWhere((i) => i.cartKey == cartKey);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        samosaId: samosa.id,
        name: samosa.name,
        price: samosa.price,
        quantity: quantity,
        emoji: samosa.imageEmoji,
        imageAsset: samosa.imageAsset,
        extraChutneyId: chutneyId,
        extraChutneyName: chutney?.name,
        extraChutneyPrice: chutney?.price ?? 0.0,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String samosaId, {String? chutneyId}) {
    final cartKey = '$samosaId-${chutneyId ?? "none"}';
    final index = _cartItems.indexWhere((i) => i.cartKey == cartKey);
    
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
      return;
    }

    // Fallback by samosaId if chutneyId wasn't specified
    final fallbackIndex = _cartItems.lastIndexWhere((i) => i.samosaId == samosaId);
    if (fallbackIndex >= 0) {
      if (_cartItems[fallbackIndex].quantity > 1) {
        _cartItems[fallbackIndex].quantity--;
      } else {
        _cartItems.removeAt(fallbackIndex);
      }
      notifyListeners();
    }
  }

  void deleteCartItem(CartItem item) {
    _cartItems.removeWhere((i) => i.cartKey == item.cartKey);
    notifyListeners();
  }

  void deleteFromCart(String samosaId) {
    _cartItems.removeWhere((i) => i.samosaId == samosaId);
    notifyListeners();
  }

  int getQuantity(String samosaId) {
    return _cartItems
        .where((i) => i.samosaId == samosaId)
        .fold(0, (sum, i) => sum + i.quantity);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Public method to trigger rebuild from outside
  void notifyCart() => notifyListeners();

  Order placeOrder({
    required String address,
    String? scheduledTime,
    required String paymentMethod,
  }) {
    final order = Order(
      id: _uuid.v4().substring(0, 8).toUpperCase(),
      items: _cartItems
          .map((ci) => OrderItem(
                samosaId: ci.samosaId,
                name: ci.name,
                price: ci.price,
                quantity: ci.quantity,
                emoji: ci.emoji,
                imageAsset: ci.imageAsset,
                extraChutneyName: ci.extraChutneyName,
                extraChutneyPrice: ci.extraChutneyPrice,
              ))
          .toList(),
      address: address,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    _cartItems.clear();
    notifyListeners();

    // Simulate order status updates
    _simulateProgress(order);

    return order;
  }

  void _simulateProgress(Order order) {
    Future.delayed(const Duration(seconds: 8), () {
      order.status = OrderStatus.preparing;
      notifyListeners();
    });
    Future.delayed(const Duration(seconds: 18), () {
      order.status = OrderStatus.readyForPickup;
      notifyListeners();
    });
    Future.delayed(const Duration(seconds: 30), () {
      order.status = OrderStatus.outForDelivery;
      notifyListeners();
    });
    Future.delayed(const Duration(seconds: 50), () {
      order.status = OrderStatus.delivered;
      notifyListeners();
    });
  }
}
