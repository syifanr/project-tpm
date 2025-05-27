
import 'package:flutter/material.dart';
import 'package:tokomakeup/api/apiService.dart';
import 'package:tokomakeup/models/contentModel.dart';
import 'package:tokomakeup/pages/detailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokomakeup/pages/favoritesPage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final String brand = 'maybelline'; // Default brand
  int _currentIndex = 0;

  // Mendapatkan username dari SharedPreferences
  Future<String?> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Logout dan menghapus username dari SharedPreferences
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacementNamed(context, '/');
  }

  // Mengambil data dari API atau menampilkan halaman favorit
  Widget _getSelectedPage(int index) {
  if (index == 1) {
    return const FavoritePage();  // Menu favorit
  }
  return FutureBuilder<List<ContentModel>>(
    future: ApiService.fetchData(brand),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      final data = snapshot.data ?? [];
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,           // 2 kolom
          crossAxisSpacing: 12,        // jarak antar kolom
          mainAxisSpacing: 12,         // jarak antar baris
          childAspectRatio: 0.7,       // tinggi lebar item (atur agar pas)
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: item.id,
                    name: item.name,
                    pictureId: item.imageUrl,
                    description: item.description,
                    // rating: item.rating ?? 'No rating',
                    price: item.price,
                    priceSign: item.priceSign,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      item.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${item.priceSign}${item.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/');
          });
          return const SizedBox.shrink();
        }
        String username = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Welcome, $username!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(221, 246, 74, 148),
            centerTitle: true,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
            ],
          ),
          body: _getSelectedPage(_currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket),
                label: 'Keranjang',
              ),
            ],
          ),
        );
      },
    );
  }
}
