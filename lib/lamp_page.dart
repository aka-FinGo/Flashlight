import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Rang tanlagich paketi
import 'main.dart'; 

class LampPage extends StatefulWidget {
  const LampPage({super.key});

  @override
  State<LampPage> createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  double lampValue = 0.0;
  Color activeColor = const Color(0xffbd8934);
  bool isTorchOn = false;
  Timer? sleepTimer;

  @override
  void initState() {
    super.initState();
    _checkSleepTimer();
  }

  void _checkSleepTimer() {
    if (globalSleepTimerMinutes > 0) {
      sleepTimer = Timer(Duration(minutes: globalSleepTimerMinutes), () {
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

  ///*** RANG TANLAGICH OYNASI ***///
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = activeColor; // Tanlanayotgan vaqtinchalik rang
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text("Rangni tanlang", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: activeColor,
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
                setState(() => activeColor = tempColor); // Asosiy rangni o'zgartirish
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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          ///*** FON RANGI ***///
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: getBGColor(lampValue, activeColor),
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                ///*** Lid *** ///
                Container(
                  width: 130,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xff161614), Colors.grey.shade500, const Color(0xff161614)],
                    ),
                    boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 30, offset: Offset(5, 5))],
                  ),
                ),

                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ///*** Flame Light Shadow *** ///
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: getFlameLightShadowColor(lampValue, activeColor),
                            blurRadius: 100 + (400 * lampValue), 
                            spreadRadius: 80 * lampValue,        
                            offset: const Offset(10, -10),
                          ),
                        ],
                      ),
                    ),

                    ///*** Flame Light *** ///
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20 + (10 * lampValue),
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: getFlameLightColor(lampValue, activeColor),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: getFlameLightInnerShadowColor(lampValue, activeColor),
                            blurRadius: 30 + (40 * lampValue),
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 128,
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade500, Colors.transparent, Colors.grey.shade900.withOpacity(0.1),
                            Colors.transparent, Colors.transparent, Colors.grey.shade900.withOpacity(0.1),
                            Colors.transparent, Colors.grey.shade500,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 40,
                  width: 130,
                  decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 30, offset: Offset(0, 10))],
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade800, Colors.black, Colors.grey.shade800, Colors.black, Colors.grey.shade800],
                    ),
                  ),
                ),
                
                const Spacer(),

                ///*** RANG TANLASH, PALITRA VA FONAR TUGMALARI ***///
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _colorBtn(const Color(0xffbd8934)), // Oltin
                      _colorBtn(Colors.blueAccent),       // Ko'k
                      _colorBtn(Colors.redAccent),        // Qizil
                      _colorBtn(Colors.greenAccent),      // Yashil
                      
                      // PALITRA TUGMASI (O'zingiz xohlagan rangni tanlash)
                      GestureDetector(
                        onTap: _openColorPicker,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.color_lens, size: 18, color: Colors.white),
                        ),
                      ),

                      const SizedBox(width: 10),
                      
                      // Fonar
                      IconButton(
                        icon: Icon(
                          isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                          color: isTorchOn ? Colors.white : Colors.white54,
                          size: 30,
                        ),
                        onPressed: _toggleTorch,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          ///*** VERTIKAL SLIDER (O'NG TARAFDA) ***///
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SizedBox(
                height: 300, 
                child: RotatedBox(
                  quarterTurns: 3, 
                  child: Slider(
                    inactiveColor: Colors.black45,
                    activeColor: activeColor,
                    thumbColor: Colors.white,
                    value: lampValue,
                    onChanged: (newValue) {
                      setState(() {
                        lampValue = newValue;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          ///*** ORQAGA QAYTISH TUGMASI ***///
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBtn(Color color) {
    bool isSelected = activeColor == color;
    return GestureDetector(
      onTap: () => setState(() => activeColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.8), blurRadius: 15)] : [],
        ),
      ),
    );
  }
}

// Rang funksiyalari
final List<Color> bgColor1 = [const Color(0xff161614), const Color(0xff161614)];
final Color offColor = Colors.black;
final List<Color> flameOffColor = [Colors.black, Colors.grey];
final List<Color> flameLightColor1 = [Colors.white, Colors.white];

List<Color> getBGColor(double lampValue, Color activeColor) {
  if (lampValue > 0.8) {
    return [activeColor.withOpacity(0.6), activeColor.withOpacity(0.3), activeColor.withOpacity(0.1), const Color(0xff161614), const Color(0xff161614)];
  } else if (lampValue > 0.4 && lampValue < 0.8) {
    return [activeColor.withOpacity(0.3), activeColor.withOpacity(0.1), const Color(0xff161614)];
  } else {
    return bgColor1;
  }
}

List<Color> getFlameLightColor(double lampValue, Color activeColor) {
  if (lampValue > 0.8) return [activeColor, activeColor.withOpacity(0.7), Colors.white];
  if (lampValue > 0.4 && lampValue < 0.8) return [activeColor.withOpacity(0.8), activeColor.withOpacity(0.5), activeColor.withOpacity(0.3)];
  if (lampValue > 0.1 && lampValue < 0.5) return flameLightColor1;
  return flameOffColor;
}

Color getFlameLightShadowColor(double lampValue, Color activeColor) {
  if (lampValue > 0.75) return activeColor;
  if (lampValue > 0.5 && lampValue < 0.75) return activeColor.withOpacity(0.8);
  if (lampValue > 0.1 && lampValue < 0.5) return activeColor.withOpacity(0.5);
  return offColor;
}

Color getFlameLightInnerShadowColor(double lampValue, Color activeColor) {
  if (lampValue > 0.75) return activeColor;
  if (lampValue > 0.5 && lampValue < 0.75) return activeColor.withOpacity(0.8);
  if (lampValue > 0.1 && lampValue < 0.5) return Colors.white;
  return offColor;
}
