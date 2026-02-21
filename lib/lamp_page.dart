import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart'; // Standart fonar uchun (pubspec.yaml ga qo'shish esdan chiqmasin)

class LampPage extends StatefulWidget {
  const LampPage({super.key});

  @override
  State<LampPage> createState() => _LampPageState();
}

class _LampPageState extends State<LampPage> {
  double lampValue = 0.0;
  Color activeColor = const Color(0xffbd8934); // Standart oltin rang
  bool isTorchOn = false;

  // Fonarni yoqish/o'chirish funksiyasi
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // FON RANGI (Yorug'lik tarqatishi oshirildi)
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: getBGColor(lampValue, activeColor), // Sizning funksiyangizga rang ulandi
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
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
                      colors: [
                        const Color(0xff161614),
                        Colors.grey.shade500,
                        const Color(0xff161614),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 30,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                ),

                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ///*** Flame Light Shadow (YORQINLIK KESKIN OSHIRILDI) *** ///
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: getFlameLightShadowColor(lampValue, activeColor),
                            blurRadius: 100 + (150 * lampValue), // Yoyilish radiusi kattalashdi
                            spreadRadius: 30 * lampValue,        // Atrofga nur sochishi qo'shildi
                            offset: const Offset(10, -10),
                          ),
                        ],
                      ),
                    ),

                    ///*** Flame Light *** ///
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 20,
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
                            blurRadius: 30 + (20 * lampValue),
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
                            Colors.grey.shade500,
                            Colors.transparent,
                            Colors.grey.shade900.withOpacity(0.2),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.grey.shade900.withOpacity(0.2),
                            Colors.transparent,
                            Colors.grey.shade500,
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
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade800,
                        Colors.black,
                        Colors.grey.shade800,
                        Colors.black,
                        Colors.grey.shade800,
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),

                ///*** RANG TANLASH VA FONAR TUGMALARI ***///
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _colorBtn(const Color(0xffbd8934)), // Original Oltin
                    _colorBtn(Colors.blueAccent),
                    _colorBtn(Colors.redAccent),
                    _colorBtn(Colors.greenAccent),
                    const SizedBox(width: 20),
                    // Fonar yoqish tugmasi
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

                ///*** SLIDER (Tagidan tepaga surildi) ***///
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0, top: 20.0),
                  child: Slider(
                    inactiveColor: Colors.black,
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
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Rang tugmasi yasovchi yordamchi widget
  Widget _colorBtn(Color color) {
    bool isSelected = activeColor == color;
    return GestureDetector(
      onTap: () => setState(() => activeColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10)]
              : [],
        ),
      ),
    );
  }
}

// =========================================================================
// SIZNING 109 QATOR KODINGIZ (Mantig'i to'liq saqlab qolingan holda 
// foydalanuvchi tanlagan rangga (activeColor) moslashadigan qilindi)
// =========================================================================

final List<Color> bgColor1 = [const Color(0xff161614), const Color(0xff161614)];
final Color offColor = Colors.black;
final List<Color> flameOffColor = [Colors.black, Colors.grey];
final List<Color> flameLightColor1 = [Colors.white, Colors.white];

List<Color> getBGColor(double lampValue, Color activeColor) {
  if (lampValue > 0.8) {
    return [
      activeColor.withOpacity(0.3),
      activeColor.withOpacity(0.15),
      const Color(0xff161614),
      const Color(0xff161614),
      const Color(0xff161614),
    ];
  } else if (lampValue > 0.4 && lampValue < 0.8) {
    return [
      activeColor.withOpacity(0.15),
      const Color(0xff161614),
      const Color(0xff161614),
    ];
  } else {
    return bgColor1;
  }
}

List<Color> getFlameLightColor(double lampValue, Color activeColor) {
  if (lampValue > 0.8) {
    return [
      activeColor,
      activeColor.withOpacity(0.7),
      Colors.white,
    ];
  } else if (lampValue > 0.4 && lampValue < 0.8) {
    return [
      activeColor.withOpacity(0.8),
      activeColor.withOpacity(0.5),
      activeColor.withOpacity(0.3),
    ];
  } else if (lampValue > 0.1 && lampValue < 0.5) {
    return flameLightColor1;
  } else {
    return flameOffColor;
  }
}

Color getFlameLightShadowColor(double lampValue, Color activeColor) {
  if (lampValue > 0.75) {
    return activeColor;
  } else if (lampValue > 0.5 && lampValue < 0.75) {
    return activeColor.withOpacity(0.6);
  } else if (lampValue > 0.1 && lampValue < 0.5) {
    return Colors.white38;
  } else {
    return offColor;
  }
}

Color getFlameLightInnerShadowColor(double lampValue, Color activeColor) {
  if (lampValue > 0.75) {
    return activeColor;
  } else if (lampValue > 0.5 && lampValue < 0.75) {
    return activeColor.withOpacity(0.6);
  } else if (lampValue > 0.1 && lampValue < 0.5) {
    return Colors.white;
  } else {
    return offColor;
  }
}
