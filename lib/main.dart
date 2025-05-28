import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tokomakeup/pages/loginPage.dart';
import 'package:tokomakeup/pages/listPage.dart';
import 'package:tokomakeup/models/cart_item.dart';
import 'package:tokomakeup/models/notification_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Daftarkan adapter
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(NotificationItemAdapter());

  // Buka box Hive
  await Hive.openBox('users');
  await Hive.openBox('favorites');
  await Hive.openBox<CartItem>('cart_box');
  await Hive.openBox('makeup_cache');
  await Hive.openBox<NotificationItem>('notifications');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeup Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), checkLogin);
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn =
        prefs.getBool('is_logged_in') ??
        false; // ✅ disamakan dengan loginPage.dart

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ListPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
