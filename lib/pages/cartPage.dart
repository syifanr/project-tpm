import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokomakeup/models/cart_item.dart';
import 'package:tokomakeup/pages/checkoutPage.dart';
import 'package:tokomakeup/pages/ListPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartItem> cartBox;
  String currentUser = '';
  String selectedCurrency = 'EUR';

  final Map<String, double> conversionRates = {
    'EUR': 1.0,
    'USD': 1.1,
    'IDR': 17000.0,
  };

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartItem>('cart_box');
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('username') ?? '';
    });
  }

  void _removeItem(String key) {
    cartBox.delete(key);
    setState(() {});
  }

  String getConvertedPrice(String priceStr) {
    double basePrice = double.tryParse(priceStr) ?? 0.0;
    double converted = basePrice * conversionRates[selectedCurrency]!;
    String symbol =
        selectedCurrency == 'IDR'
            ? 'Rp'
            : selectedCurrency == 'USD'
            ? '\$'
            : '€';
    return '$symbol${converted.toStringAsFixed(selectedCurrency == 'IDR' ? 0 : 2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final cartKeys =
        cartBox.keys
            .where((key) => key.toString().startsWith(currentUser))
            .toList();
    final userCartItems =
        cartKeys
            .map((key) => MapEntry(key.toString(), cartBox.get(key)!))
            .toList();

    if (userCartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.pinkAccent.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops, your cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ready to fill it with some favorites?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(221, 246, 74, 148),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                Icons.shopping_bag,
                color: Colors.white.withOpacity(0.7),
              ),

              label: const Text(
                'Start Shopping',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose Currency:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.pinkAccent,
                ),
              ),
              DropdownButton<String>(
                value: selectedCurrency,
                items: const [
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                  DropdownMenuItem(value: 'IDR', child: Text('IDR')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCurrency = value;
                    });
                  }
                },
                dropdownColor: Colors.pink.shade50,
                style: TextStyle(
                  color: Colors.pink.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: userCartItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final key = userCartItems[index].key;
              final item = userCartItems[index].value;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shadowColor: Colors.pinkAccent.withOpacity(0.3),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${getConvertedPrice(item.price)} x ${item.quantity}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _removeItem(key),
                    tooltip: 'Delete item',
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CheckoutPage(selectedCurrency: selectedCurrency),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(221, 246, 74, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                shadowColor: Colors.pinkAccent.shade200,
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
