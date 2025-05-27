import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokomakeup/models/contentModel.dart';  // Pastikan path ContentModel sesuai
import 'package:tokomakeup/pages/detailPage.dart';    // Pastikan path DetailPage sesuai
import 'dart:convert';  // Import untuk menangani JSON encoding/decoding

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ContentModel> favoriteProducts = [];

  // Mendapatkan daftar favorit dari SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    
    if (savedFavorites != null && savedFavorites.isNotEmpty) {
      setState(() {
        favoriteProducts = savedFavorites
            .map((item) => ContentModel.fromJson(
                Map<String, dynamic>.from(json.decode(item)))).toList();
      });
    }
  }

  // Menambahkan produk ke favorit
  Future<void> _addToFavorites(ContentModel product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites') ?? [];
    
    savedFavorites.add(json.encode(product.toJson())); // Encode produk ke JSON
    await prefs.setStringList('favorites', savedFavorites);
    _loadFavorites(); // Memuat ulang favorit
  }

  // Menghapus produk dari favorit
  Future<void> _removeFromFavorites(ContentModel product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites') ?? [];

    savedFavorites.removeWhere((item) =>
        json.encode(product.toJson()) == item);  // Hapus berdasarkan JSON string
    
    await prefs.setStringList('favorites', savedFavorites);
    _loadFavorites(); // Memuat ulang favorit
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Memuat favorit saat halaman pertama kali dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
        backgroundColor: const Color.fromARGB(221, 246, 74, 148),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(child: Text('No favorites added yet!'))
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          id: product.id,
                          name: product.name,
                          pictureId: product.imageUrl,
                          description: product.description,
                          // rating: product.rating.toString(),
                          price: product.price,
                          priceSign: product.priceSign,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 100);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.brand,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_border_rounded,
                                      color: Colors.yellow,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    // Text(
                                    //   product.rating.toString(),
                                    //   style: const TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.grey,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${product.priceSign}${product.price}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _removeFromFavorites(product);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
