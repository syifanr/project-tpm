// // Halaman Saran & Kesan Mata Kuliah
// class FeedbackPage extends StatefulWidget {
//   @override
//   State<FeedbackPage> createState() => _FeedbackPageState();
// }

// class _FeedbackPageState extends State<FeedbackPage> {
//   final TextEditingController _controller = TextEditingController();

//   void submitFeedback() {
//     if (_controller.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Isi saran dan kesan terlebih dahulu')));
//       return;
//     }
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Terima kasih atas saran dan kesan Anda!')));
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(children: [
//         Text('Saran & Kesan Mata Kuliah Teknologi dan Pemrograman Mobile',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//         SizedBox(height: 12),
//         TextField(
//           controller: _controller,
//           maxLines: 5,
//           decoration: InputDecoration(
//               border: OutlineInputBorder(), hintText: 'Tulis saran dan kesan Anda di sini'),
//         ),
//         SizedBox(height: 12),
//         ElevatedButton(onPressed: submitFeedback, child: Text('Kirim'))
//       ]),
//     );
//   }
// }
