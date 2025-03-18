import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class UserProfile {
  String name;
  String email;

  UserProfile({required this.name, required this.email});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final UserProfile _userProfile =
      UserProfile(name: 'Fai', email: 'aku@gmail.com');
  final List<String> _calculationHistory = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _selectedIndex == 0
              ? Calculator(onCalculation: (result) {
                  setState(() {
                    _calculationHistory.add(result);
                  });
                })
              : _selectedIndex == 1
                  ? CalculationHistory(calculationHistory: _calculationHistory)
                  : UserProfileDisplay(userProfile: _userProfile),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Kalkulator'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  final Function(String) onCalculation;

  const Calculator({super.key, required this.onCalculation});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '0';
  String _history = '';

  void _handleInput(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _history = '';
      } else if (value == 'Del') {
        _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
      } else if (value == '±') {
        _display = (double.parse(_display) * -1).toString();
      } else if (value == '.') {
        if (!_display.contains('.')) _display += '.';
      } else if (value == '=') {
        try {
          final expression = _display.replaceAll('×', '*').replaceAll('÷', '/');
          final evalResult = Parser().parse(expression).evaluate(EvaluationType.REAL, ContextModel());
          _history = '$_display = ';
          _display = (evalResult % 1 == 0) ? evalResult.toInt().toString() : evalResult.toString();
          widget.onCalculation('$_history$_display');
        } catch (e) {
          _display = 'Error';
        }
      } else {
        _display = _display == '0' ? value : _display + value;
      }
    });
  }

  Widget _buildButton(String text, {Color color = Colors.white}) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(80, 80), // Sesuaikan ukuran tombol di sini
        ),
        onPressed: () => _handleInput(text),
        child: Text(
          text,
 style: TextStyle(
            fontSize: 20, // Sesuaikan ukuran font
            color: color == Colors.white ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerRight,
          child: Text(
            _display,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildButton('C', color: Colors.grey),
              _buildButton('Del', color: Colors.grey),
              _buildButton('±', color: Colors.grey),
              _buildButton('÷', color: Colors.orange),
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('×', color: Colors.orange),
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('-', color: Colors.orange),
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('+', color: Colors.orange),
              _buildButton('.'),
              _buildButton('0'),
              _buildButton('00'),
              _buildButton('=', color: Colors.orange),
            ],
          ),
        ),
      ],
    );
  }
}

class CalculationHistory extends StatelessWidget {
  final List<String> calculationHistory;

  const CalculationHistory({super.key, required this.calculationHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: calculationHistory.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(calculationHistory[index]),
        );
      },
    );
  }
}

class UserProfileDisplay extends StatelessWidget {
  final UserProfile userProfile;

  const UserProfileDisplay({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Nama: ${userProfile.name}', style: const TextStyle(fontSize: 24)),
        Text('Email: ${userProfile.email}', style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}