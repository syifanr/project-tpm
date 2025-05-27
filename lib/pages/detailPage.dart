import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String id;
  final String name;
  final String pictureId;
  final String description;
  final String price;
  final String priceSign;

  const DetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.pictureId,
    required this.description,
    required this.price,
    required this.priceSign,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(221, 246, 74, 148);

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dengan border dan shadow
            Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  pictureId,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 320,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 320,
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 320,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nama produk
            Text(
              name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 8),

            // Harga dengan style yang menonjol
            Text(
              "$priceSign$price",
              style: TextStyle(
                fontSize: 22,
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
            const SizedBox(height: 20),

            // Section deskripsi
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 32),

            // Tombol Add to Cart dengan efek shadow & rounded
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produk "$name" ditambahkan ke keranjang!'),
                      backgroundColor: primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: primaryColor.withOpacity(0.6),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
