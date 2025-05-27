
// // Halaman Profil dengan Gambar, Logout & Menu Konversi
// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String? email;

//   // Contoh data konversi waktu & mata uang sederhana
//   String currencyFrom = 'IDR';
//   String currencyTo = 'USD';
//   double currencyRate = 0.000067; // Contoh: 1 IDR = 0.000067 USD
//   final currencies = ['IDR', 'USD', 'SGD'];
//   final timezones = ['WIB (GMT+7)', 'WITA (GMT+8)', 'WIT (GMT+9)', 'London (GMT+0)'];

//   String selectedTimezone = 'WIB (GMT+7)';

//   double amount = 100000; // contoh nilai uang

//   Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (_) => LoginPage()));
//   }

//   Future<void> loadUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       email = prefs.getString('email') ?? 'User';
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//   }

//   String convertCurrency(double amount, String from, String to) {
//     // Contoh simple conversion berdasarkan kurs tetap
//     Map<String, double> ratesToIDR = {
//       'IDR': 1,
//       'USD': 15000,
//       'SGD': 11000,
//     };
//     double inIDR = amount * (ratesToIDR[from] ?? 1);
//     double converted = inIDR / (ratesToIDR[to] ?? 1);
//     return converted.toStringAsFixed(2);
//   }

//   String convertTime(String fromTz, String toTz, DateTime time) {
//     // Contoh manual offset (jam) - ini bisa dikembangkan dengan package timezone
//     Map<String, int> tzOffset = {
//       'WIB (GMT+7)': 7,
//       'WITA (GMT+8)': 8,
//       'WIT (GMT+9)': 9,
//       'London (GMT+0)': 0,
//     };
//     int fromOffset = tzOffset[fromTz] ?? 7;
//     int toOffset = tzOffset[toTz] ?? 0;

//     DateTime utc = time.subtract(Duration(hours: fromOffset));
//     DateTime converted = utc.add(Duration(hours: toOffset));
//     return converted.toLocal().toString();
//   }

//   String fromTimezone = 'WIB (GMT+7)';

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: AssetImage('assets/profile_placeholder.png'),
//           ),
//           SizedBox(height: 12),
//           Text(email ?? '', style: TextStyle(fontSize: 18)),
//           SizedBox(height: 24),

//           // Konversi Mata Uang
//           Text('Konversi Mata Uang', style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               DropdownButton<String>(
//                 value: currencyFrom,
//                 items: currencies
//                     .map((e) => DropdownMenuItem(child: Text(e), value: e))
//                     .toList(),
//                 onChanged: (val) {
//                   if (val != null) setState(() => currencyFrom = val);
//                 },
//               ),
//               Icon(Icons.arrow_right_alt),
//               DropdownButton<String>(
//                 value: currencyTo,
//                 items: currencies
//                     .map((e) => DropdownMenuItem(child: Text(e), value: e))
//                     .toList(),
//                 onChanged: (val) {
//                   if (val != null) setState(() => currencyTo = val);
//                 },
//               ),
//             ],
//           ),
//           Text(
//               '${amount.toStringAsFixed(0)} $currencyFrom = ${convertCurrency(amount, currencyFrom, currencyTo)} $currencyTo'),
//           SizedBox(height: 24),

//           // Konversi Waktu
//           Text('Konversi Waktu', style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           DropdownButton<String>(
//             value: selectedTimezone,
//             items:
//                 timezones.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
//             onChanged: (val) {
//               if (val != null) setState(() => selectedTimezone = val);
//             },
//           ),
//           Text(
//               'Waktu sekarang di $selectedTimezone:\n${convertTime(fromTimezone, selectedTimezone, DateTime.now())}'),
//           SizedBox(height: 24),

//           ElevatedButton(onPressed: logout, child: Text('Logout'))
//         ],
//       ),
//     );
//   }
// }