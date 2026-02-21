import 'dart:async';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'lamp_page.dart';

int globalSleepTimerMinutes = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lampa va Fonar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSosOn = false;
  Timer? sosTimer;
  bool isWakelockOn = false;

  void _toggleSos() async {
    if (isSosOn) {
      sosTimer?.cancel();
      try { await TorchLight.disableTorch(); } catch (_) {}
      setState(() => isSosOn = false);
    } else {
      setState(() => isSosOn = true);
      bool torchState = false;
      sosTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) async {
        try {
          if (torchState) {
            await TorchLight.disableTorch();
          } else {
            await TorchLight.enableTorch();
          }
          torchState = !torchState;
        } catch (_) {}
      });
    }
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text("Sozlamalar", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Ekran o'chmasligi", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Ilova ishlaganda ekran doim yoniq turadi", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    activeColor: const Color(0xffbd8934),
                    value: isWakelockOn,
                    onChanged: (val) {
                      setDialogState(() => isWakelockOn = val);
                      if (val) WakelockPlus.enable(); else WakelockPlus.disable();
                    },
                  ),
                  const Divider(color: Colors.white24),
                  const Text("Avtomatik o'chish taymeri (Daqiqa)", style: TextStyle(color: Colors.white)),
                  Slider(
                    activeColor: const Color(0xffbd8934),
                    inactiveColor: Colors.white24,
                    min: 0,
                    max: 60,
                    divisions: 12,
                    label: globalSleepTimerMinutes == 0 ? "O'chiq" : "$globalSleepTimerMinutes daq",
                    value: globalSleepTimerMinutes.toDouble(),
                    onChanged: (val) {
                      setDialogState(() => globalSleepTimerMinutes = val.toInt());
                    },
                  ),
                  Text(
                    globalSleepTimerMinutes == 0 ? "Taymer o'chirilgan" : "$globalSleepTimerMinutes daqiqadan so'ng chiroq o'chadi",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Yopish", style: TextStyle(color: Color(0xffbd8934))),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    sosTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff161614),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Fonar & Lampa"),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: _openSettings),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (isSosOn) _toggleSos(); 
                // Taymer vaqtini LampPage ga to'g'ridan-to'g'ri jo'natamiz
                Navigator.push(context, MaterialPageRoute(builder: (context) => LampPage(timerMinutes: globalSleepTimerMinutes)));
              },
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(colors: [Color(0xffbd8934), Color(0xff75431b)]),
                  boxShadow: [BoxShadow(color: const Color(0xffbd8934).withOpacity(0.5), blurRadius: 30, spreadRadius: 5)]
                ),
                child: const Center(child: Icon(Icons.lightbulb_outline, size: 80, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSosOn ? Colors.redAccent : Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              icon: Icon(isSosOn ? Icons.warning : Icons.warning_amber, color: Colors.white),
              label: Text(isSosOn ? "SOS O'CHIRISH" : "SOS REJIMI (MILTILLASH)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: _toggleSos,
            ),
          ],
        ),
      ),
    );
  }
}
