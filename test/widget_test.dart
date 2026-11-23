import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:samosa_app/main.dart';
import 'package:samosa_app/models/samosa_item.dart';
import 'package:samosa_app/providers/cart_provider.dart';
import 'package:samosa_app/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SamosaApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Samosa House'), findsOneWidget);
  });

  test('Menu does not contain chocolate samosa', () {
    final hasChocolate = samosaMenu.any(
      (item) =>
          item.name.toLowerCase().contains('chocolate') ||
          item.description.toLowerCase().contains('nutella') ||
          item.category.toLowerCase().contains('dessert'),
    );
    expect(hasChocolate, isFalse);
    expect(samosaMenu.length, 6);
  });

  test('Available chutneys contain mint and sweet chutney with price', () {
    expect(availableChutneys.isNotEmpty, isTrue);
    final mintChutney = availableChutneys.firstWhere((c) => c.id == 'hari_chutney');
    expect(mintChutney.price, 10.0);
    final combo = availableChutneys.firstWhere((c) => c.id == 'both_chutney');
    expect(combo.price, 18.0);
  });

  test('Cart provider handles extra chutney and pricing correctly', () {
    final cart = CartProvider();
    final samosa = samosaMenu.first; // Classic Aloo Samosa (₹29)
    final chutney = availableChutneys.first; // Extra Mint Chutney (+₹10)

    cart.addToCart(samosa, chutney: chutney, quantity: 2);
    expect(cart.cartCount, 2);
    // (29 + 10) * 2 = 78
    expect(cart.subtotal, 78.0);
    expect(cart.cartItems.first.extraChutneyName, chutney.name);
    expect(cart.cartItems.first.extraChutneyPrice, 10.0);
  });
}
