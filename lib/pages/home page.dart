// // HOME PAGE dengan Bottom Navigation
// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//   final List<Widget> _pages = [
//     ProductListPage(),
//     FeedbackPage(),
//     ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Makeup Store'),
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.pink,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Produk'),
//           BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Saran & Kesan'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//         ],
//         onTap: (i) {
//           setState(() {
//             _currentIndex = i;
//           });
//         },
//       ),
//     );
//   }
// }