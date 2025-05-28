import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'instagram': 'jeslyn.vh',
      'name': 'Jeslyn Vicky Hanjaya',
      'nim': '123220150',
      'image': 'assets/media/jeslyn.jpg',
    },
    {
      'instagram': 'syiifanr',
      'name': 'Syifa Nur Ramadhani',
      'nim': '123220194',
      'image': 'assets/media/syifa.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFE6E6FA)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              Center(
                child: Text(
                  'Kelompok 7',
                  style: TextStyle(
                    fontSize: 28, // agak lebih besar biar lebih impactful
                    fontWeight:
                        FontWeight.w900, // lebih bold, tapi tetap elegan
                    color: const Color.fromARGB(221, 246, 74, 148),
                    letterSpacing:
                        1.5, // spasi huruf biar kelihatan lebih rapi dan mewah
                    shadows: [
                      Shadow(
                        blurRadius: 12.0, // blur lebih halus dan lebar
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(3.0, 3.0),
                      ),
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.pinkAccent.withOpacity(
                          0.4,
                        ), // kasih glow pink lembut
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Looping profile cards
              ...members.map((member) => _memberCard(member)).toList(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _memberCard(Map<String, String> member) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image kecil
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                member['image']!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 80, color: Colors.pink);
                },
              ),
            ),
          ),

          SizedBox(width: 16),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  member['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 159, 41, 80),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    member['nim']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFF56040),
                        Color(0xFFFF0080),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "@${member['instagram']!}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
