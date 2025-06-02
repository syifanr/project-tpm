import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tokomakeup/models/cart_item.dart'; // model CartItem Hive

class DetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String pictureId;
  final String description;
  final String price;
  final String priceSign;
  final String userId; 

  final String category;
  final String productType;
  final List<String> tagList;

  const DetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.pictureId,
    required this.description,
    required this.price,
    required this.priceSign,
    required this.userId,
    required this.category,
    required this.productType,
    required this.tagList,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Box<CartItem> cartBox;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartItem>('cart_box');
  }

  void addToCart() {
    final String key = '${widget.userId}_${widget.id}'; // ← ini penting!
    final existingItem = cartBox.get(key);

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      cartBox.put(key, updatedItem);
    } else {
      cartBox.put(
        key,
        CartItem(
          id: widget.id,
          name: widget.name,
          imageUrl: widget.pictureId,
          price: widget.price,
          priceSign: widget.priceSign,
          quantity: 1,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product "${widget.name}" added to cart!'),
        backgroundColor: const Color.fromARGB(221, 246, 74, 148),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(221, 246, 74, 148);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Details", style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFE6E6FA)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  shadowColor: primaryColor.withOpacity(0.3),
                  child: Image.network(
                    widget.pictureId,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 320,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 320,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 320,
                        child: Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                            color: primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category.isNotEmpty ? widget.category : '-',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.productType.isNotEmpty ? widget.productType : '-',
                      style: TextStyle(
                        color: Colors.pink.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "€${widget.price}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: primaryColor.withOpacity(0.5),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.7),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
