import 'package:flutter/material.dart';

class LampPage extends StatefulWidget {
  const LampPage({super.key});

  @override
  State<LampPage> createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  // Yorqinlik darajasi (Slayder uchun)
  double _brightness = 0.5;

  // Tanlangan rang (Lampaning nuri uchun)
  Color _selectedColor = const Color(0xFFFFD700); // Oltin rang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fon Yorug'lik Effekti (Radial Gradient)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8 + (_brightness * 0.7), // Yorqinlikka qarab kengayadi
                  colors: [
                    _selectedColor.withOpacity(0.8 * _brightness), // Markaziy yorug'lik
                    _selectedColor.withOpacity(0.4 * _brightness),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 2. Orqaga qaytish tugmasi
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. Asosiy Kontent (Lampa, Slayder, Tugmalar)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // --- LAMPA ---
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Shisha korpus
                    Container(
                      width: 140,
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                    ),
                    // Ichki yorug'lik filamenti
                    Positioned(
                      bottom: 50, // Asosdan yuqoriroqda
                      child: Container(
                        width: 20,
                        height: 150,
                        decoration: BoxDecoration(
                          color: _selectedColor.withOpacity(0.8 + (0.2 * _brightness)),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _selectedColor,
                              blurRadius: 30 * _brightness + 20,
                              spreadRadius: 5 * _brightness,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Qora asos (Taglik)
                    Container(
                      width: 142,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),

                // --- GORIZONTAL SLAYDER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                    ),
                    child: Slider(
                      value: _brightness,
                      min: 0.0,
                      max: 1.0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      thumbColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _brightness = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- PASTKI TUGMALAR QATORI ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildColorButton(const Color(0xFFC5A05B)), // Oltin/Jigarrang
                      _buildColorButton(const Color(0xFF4285F4)), // Ko'k
                      _buildColorButton(const Color(0xFFEA4335)), // Qizil
                      _buildColorButton(const Color(0xFF34A853)), // Yashil
                      const SizedBox(width: 20),
                      _buildIconButton(Icons.color_lens), // Palitra
                      const SizedBox(width: 10),
                      _buildIconButton(Icons.flashlight_off), // Fonar o'chiq
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

  // Rangli dumaloq tugma yaratish uchun yordamchi funksiya
  Widget _buildColorButton(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white, width: 3)
              : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)]
              : [],
        ),
      ),
    );
  }

  // Palitra va Fonar ikonkalari uchun yordamchi funksiya
  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
      child: Icon(icon, color: Colors.white70),
    );
  }
}
