import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokomakeup/api/apiService.dart';
import 'package:tokomakeup/models/contentModel.dart';
import 'package:tokomakeup/pages/detailPage.dart';
import 'package:tokomakeup/pages/cartPage.dart';
import 'package:tokomakeup/pages/profilePage.dart';
import 'package:tokomakeup/pages/messagePage.dart';
import 'package:tokomakeup/pages/loginPage.dart';
import 'package:tokomakeup/pages/notificationPage.dart';
import 'package:tokomakeup/pages/compassPage.dart';
import 'package:hive/hive.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final String brand = 'maybelline';
  int _currentIndex = 0;
  late Box _cacheBox;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'Filter Default';

  List<ContentModel> _allData = [];
  List<ContentModel> _filteredData = [];

  bool _isLoading = true;
  String? _error;
  String? _username;

  final Color _primaryPink = const Color.fromARGB(221, 246, 74, 148);
  final Color _softPink = const Color(0xFFF9D5E5);
  final Color _lightGray = const Color(0xFFF5F5F5);
  final Color _darkText = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _cacheBox = Hive.box('makeup_cache');
    _loadUsername();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _filterData();
      });
    });

    _loadData();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('username');
    if (user == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _username = user;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      final result = await ApiService.fetchData(brand);
      final encoded = jsonEncode(result.map((e) => e.toJson()).toList());
      _cacheBox.put(brand, encoded);
      _allData = result;
      _error = null;
    } catch (e) {
      final cachedData = _cacheBox.get(brand);
      if (cachedData != null) {
        final List decoded = jsonDecode(cachedData);
        _allData = decoded.map((e) => ContentModel.fromJson(e)).toList();
        _error = null;
      } else {
        _error = e.toString();
      }
    }
    _filterData();
    setState(() => _isLoading = false);
  }
  
  void _filterData() {
    List<ContentModel> result =
        _searchQuery.isEmpty
            ? List.from(_allData)
            : _allData.where((item) {
              final name = item.name.toLowerCase();
              final category = (item.category ?? '').toLowerCase();
              final productType = (item.productType ?? '').toLowerCase();
              return name.contains(_searchQuery) ||
                  category.contains(_searchQuery) ||
                  productType.contains(_searchQuery);
            }).toList();

    _applySort(result);
  }

  void _applySort(List<ContentModel> data) {
    switch (_sortOption) {
      case 'Price: Low to High':
        data.sort(
          (a, b) => double.tryParse(
            a.price.toString(),
          )!.compareTo(double.tryParse(b.price.toString())!),
        );
        break;
      case 'Price: High to Low':
        data.sort(
          (a, b) => double.tryParse(
            b.price.toString(),
          )!.compareTo(double.tryParse(a.price.toString())!),
        );
        break;
      case 'Name: A-Z':
        data.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'Name: Z-A':
        data.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case 'Filter Default':
      default:
        break;
    }

    setState(() {
      _filteredData = data;
    });
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        if (_isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color:
                  _primaryPink, // pake warna pink yang sudah kamu definisikan
            ),
          );
        }
        if (_error != null) return Center(child: Text('Error: $_error'));
        if (_filteredData.isEmpty) {
          return const Center(child: Text('Product is not found.'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search product...',
                        prefixIcon: Icon(Icons.search, color: _primaryPink),
                        filled: true,
                        fillColor: _lightGray,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _primaryPink.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryPink),
                        ),
                      ),
                      style: TextStyle(color: _darkText),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _sortOption,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortOption = value;
                            _filterData();
                          });
                        }
                      },
                      items:
                          [
                                'Filter Default',
                                'Price: Low to High',
                                'Price: High to Low',
                                'Name: A-Z',
                                'Name: Z-A',
                              ]
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ),
                              )
                              .toList(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: _lightGray,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _primaryPink.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryPink),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  final item = _filteredData[index];
                  return GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getString('username') ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailPage(
                                id: item.id,
                                name: item.name,
                                pictureId: item.imageUrl,
                                description: item.description,
                                price: item.price,
                                priceSign: item.priceSign,
                                userId: userId,
                                category: item.category,
                                productType: item.productType,
                                tagList: item.tagList,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.pink.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              item.imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 16,
                                  color: Colors.pinkAccent,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.category ?? '-',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 2,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.style,
                                  size: 16,
                                  color: Colors.pinkAccent,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.productType ?? '-',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                            child: Text(
                              "€${item.price}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 1:
        return const CartPage();
      case 2:
        return ProfilePage();
      case 3:
        return MessagePage();
      case 4:
      return const CompassPage();  
      default:
        return const Center(child: Text('Halaman tidak ditemukan'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_username!'),
        backgroundColor: _primaryPink,
        centerTitle: true,
        foregroundColor: Colors.white,
        actions: [
          Tooltip(
            message: 'Notification',
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Logout',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => logout(context),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFE6E6FA)],
              ),
            ),
          ),
          _getSelectedPage(_currentIndex),
        ],
      ),
           bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    print('Tapped index: $index');
    setState(() => _currentIndex = index);
  },
  backgroundColor: const Color(0xFFFFE4EC),
  selectedItemColor: Colors.pinkAccent,
  unselectedItemColor: Colors.pink.shade200,
  type: BottomNavigationBarType.fixed,  
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List', backgroundColor: Color(0xFFFFE4EC)),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Cart', backgroundColor: Color(0xFFFFE4EC)),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile', backgroundColor: Color(0xFFFFE4EC)),
    BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages', backgroundColor: Color(0xFFFFE4EC)),
    BottomNavigationBarItem(icon: Icon(Icons.navigation), label: 'Compass', backgroundColor: Color(0xFFFFE4EC)),
  ],
),


    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
