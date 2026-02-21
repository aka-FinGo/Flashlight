import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LampPage extends StatefulWidget {
  final int timerMinutes; // Asosiy oynadan keladigan taymer
  const LampPage({super.key, required this.timerMinutes});

  @override
  State<LampPage> createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  double _brightness = 0.5; // Yorqinlik darajasi
  Color _selectedColor = const Color(0xffbd8934); // Asosiy oltin rang
  bool isTorchOn = false;
  Timer? sleepTimer;

  @override
  void initState() {
    super.initState();
    _checkSleepTimer();
  }

  // Taymerni tekshirish
  void _checkSleepTimer() {
    if (widget.timerMinutes > 0) {
      sleepTimer = Timer(Duration(minutes: widget.timerMinutes), () {
        if (isTorchOn) TorchLight.disableTorch();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Taymer yakunlandi. Chiroq o'chirildi.")),
          );
        }
      });
    }
  }

  // Haqiqiy fonarni yoqish
  Future<void> _toggleTorch() async {
    try {
      if (isTorchOn) {
        await TorchLight.disableTorch();
        setState(() => isTorchOn = false);
      } else {
        await TorchLight.enableTorch();
        setState(() => isTorchOn = true);
      }
    } catch (e) {
      debugPrint("Fonar ishlamadi: $e");
    }
  }

  // Rang palitrasini ochish
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = _selectedColor; 
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text("Rangni tanlang", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                tempColor = color;
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BEKOR QILISH", style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedColor = tempColor); 
                Navigator.pop(context);
              },
              child: const Text("TANLASH", style: TextStyle(color: Color(0xffbd8934), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    sleepTimer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fon Yorug'lik Effekti (Radial Gradient)
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8 + (_brightness * 0.7),
                  colors: [
                    _selectedColor.withOpacity(0.8 * _brightness),
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

          // 3. Asosiy Kontent
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
                      bottom: 50, 
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20 + (10 * _brightness),
                        height: 150,
                        decoration: BoxDecoration(
                          color: _brightness > 0.05 ? _selectedColor.withOpacity(0.8 + (0.2 * _brightness)) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _brightness > 0.05 ? _selectedColor : Colors.transparent,
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
                      _buildColorButton(const Color(0xffbd8934)), 
                      _buildColorButton(const Color(0xFF4285F4)), 
                      _buildColorButton(const Color(0xFFEA4335)), 
                      _buildColorButton(const Color(0xFF34A853)), 
                      const SizedBox(width: 20),
                      // Palitra
                      GestureDetector(
                        onTap: _openColorPicker,
                        child: _buildIconButton(Icons.color_lens, false),
                      ),
                      const SizedBox(width: 10),
                      // Fonar
                      GestureDetector(
                        onTap: _toggleTorch,
                        child: _buildIconButton(isTorchOn ? Icons.flashlight_on : Icons.flashlight_off, isTorchOn),
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
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)] : [],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool isActive) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: isActive ? Border.all(color: Colors.white, width: 1.5) : null,
      ),
      child: Icon(icon, color: isActive ? Colors.white : Colors.white70),
    );
  }
}
