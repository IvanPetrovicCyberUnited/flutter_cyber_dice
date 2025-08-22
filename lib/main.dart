import 'dart:math';

import 'package:flutter/material.dart';

import 'dice_3d_widget.dart';
import 'snow_effect.dart';
import 'sound_effects.dart';
import 'thunder_effect.dart';
import 'volcano_effect.dart';

class Dice {
  int value;
  Dice(this.value);
}

void main() {
  runApp(const CyberDiceApp());
}

class CyberDiceApp extends StatelessWidget {
  const CyberDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Dice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CyberDiceHomePage(),
    );
  }
}

class CyberDiceHomePage extends StatefulWidget {
  const CyberDiceHomePage({super.key});

  @override
  State<CyberDiceHomePage> createState() => _CyberDiceHomePageState();
}

class _CyberDiceHomePageState extends State<CyberDiceHomePage> {
  int _diceCount = 1;
  List<Dice> _dice = [];
  int _total = 0;
  final TextEditingController _controller = TextEditingController(text: '1');
  bool _animate = false;
  String _throwMode = 'Standard';
  bool _iceThrowActive = false;
  bool _volcanoThrowActive = false;
  bool _volcanoScorched = false;
  bool _thunderThrowActive = false;
  bool _thunderDestroyed = false;

  void _rollDice() {
    if (_throwMode == 'Ice Throw') {
      SoundEffects.playSnow();
      _startIceThrow();
      return;
    }
    if (_throwMode == 'Volcano Throw') {
      SoundEffects.playVolcano();
      _startVolcanoThrow();
      return;
    }
    if (_throwMode == 'Thunder Throw') {
      SoundEffects.playThunder();
      _startThunderThrow();
      return;
    }
    SoundEffects.playStandard();
    setState(() {
      _dice = List.generate(_diceCount, (_) => Dice(_randomDiceValue()));
      _total = _dice.fold(0, (sum, die) => sum + die.value);
      _animate = true;
    });
    // Reset animation after short delay
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _animate = false);
    });
  }

  void _startIceThrow() {
    setState(() {
      _iceThrowActive = true;
      _dice = List.generate(_diceCount, (_) => Dice(_randomDiceValue()));
      _total = _dice.fold(0, (sum, die) => sum + die.value);
      _animate = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _iceThrowActive = false;
          _animate = false;
        });
      }
    });
  }

  void _startVolcanoThrow() {
    setState(() {
      _volcanoThrowActive = true;
      _volcanoScorched = false;
      _dice = List.generate(_diceCount, (_) => Dice(_randomDiceValue()));
      _total = _dice.fold(0, (sum, die) => sum + die.value);
      _animate = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _volcanoThrowActive = false;
          _volcanoScorched = true;
          _animate = false;
        });
      }
    });
  }

  void _startThunderThrow() {
    setState(() {
      _thunderThrowActive = true;
      _thunderDestroyed = false;
      _dice = List.generate(_diceCount, (_) => Dice(_randomDiceValue()));
      _total = _dice.fold(0, (sum, die) => sum + die.value);
      _animate = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _thunderThrowActive = false;
          _thunderDestroyed = true;
          _dice.clear();
          _total = 0;
          _animate = false;
        });
      }
    });
  }

  void _resetDice() {
    setState(() {
      _diceCount = 1;
      _controller.text = '1';
      _dice.clear();
      _total = 0;
      _animate = false;
      _iceThrowActive = false;
      _volcanoThrowActive = false;
      _volcanoScorched = false;
      _thunderThrowActive = false;
      _thunderDestroyed = false;
      _throwMode = 'Standard';
    });
  }

  int _randomDiceValue() => Random().nextInt(6) + 1;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final gridCrossAxisCount = isMobile ? 5 : 10;
    final gridHeight = isMobile ? 200.0 : 320.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Dice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Number of dice:'),
                const SizedBox(width: 10),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      final n = int.tryParse(val) ?? 1;
                      setState(() {
                        _diceCount = n.clamp(1, 100);
                        _controller.text = _diceCount.toString();
                        _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length));
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Slider(
                    value: _diceCount.toDouble(),
                    min: 1,
                    max: 100,
                    divisions: 99,
                    label: _diceCount.toString(),
                    onChanged: (val) {
                      setState(() {
                        _diceCount = val.round();
                        _controller.text = _diceCount.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _rollDice,
                  child: const Text('Roll'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _resetDice,
                  child: const Text('New Dice'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.deepPurple.shade50,
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Total: $_total',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Throw mode:'),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _throwMode,
                  items: const [
                    DropdownMenuItem(
                        value: 'Standard', child: Text('Standard')),
                    DropdownMenuItem(
                        value: 'Ice Throw', child: Text('❄ Ice Throw')),
                    DropdownMenuItem(
                        value: 'Volcano Throw',
                        child: Text('🌋 Volcano Throw')),
                    DropdownMenuItem(
                        value: 'Thunder Throw', child: Text('⚡ Thunder Throw')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _throwMode = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                SizedBox(
                  height: gridHeight,
                  child: _thunderDestroyed
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridCrossAxisCount,
                            childAspectRatio: 1,
                          ),
                          itemCount: _dice.length,
                          itemBuilder: (context, idx) {
                            return Dice3DWidget(
                              value: _dice[idx].value,
                              animate: _animate ||
                                  _iceThrowActive ||
                                  _volcanoThrowActive ||
                                  _thunderThrowActive,
                              burned: _volcanoScorched,
                            );
                          },
                        ),
                ),
                if (_iceThrowActive)
                  Positioned.fill(
                    child: SnowEffect(
                      active: _iceThrowActive,
                      diceCount: _diceCount,
                      width: MediaQuery.of(context).size.width,
                      height: gridHeight,
                    ),
                  ),
                if (_volcanoThrowActive)
                  Positioned.fill(
                    child: VolcanoEffect(
                      active: _volcanoThrowActive,
                      width: MediaQuery.of(context).size.width,
                      height: gridHeight,
                    ),
                  ),
                if (_thunderThrowActive || _thunderDestroyed)
                  Positioned.fill(
                    child: ThunderEffect(
                      active: _thunderThrowActive,
                      diceCount: _diceCount,
                      width: MediaQuery.of(context).size.width,
                      height: gridHeight,
                    ),
                  ),
                if (_thunderDestroyed)
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.warning, color: Colors.amber, size: 64),
                          SizedBox(height: 16),
                          Text(
                            '⚠ Bad Luck! The storm destroyed the game.',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (!_thunderDestroyed)
              Card(
                color: Colors.deepPurple.shade50,
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Total: $_total',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            if (_thunderDestroyed) const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
