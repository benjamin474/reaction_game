import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GamePage extends StatefulWidget {
  final int difficulty;

  const GamePage({super.key, required this.difficulty});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Timer _timer;
  late DateTime _startTime;
  int _timeLeft = 0;
  String _question = "";
  List<String> _options = [];
  String _correctAnswer = "";
  Color _textColor = Colors.black;
  int _score = 0;
  Map<String, dynamic>? _currentElement;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.difficulty;
    _startGame();
  }

  void _startGame() {
    _generateQuestion();
    _startTimer();
  }

  String _difficultyName(int dif){
    switch(dif){
      case 10:
        return "簡單模式";
      case 5:
        return "普通模式";
      case 3:
        return "困難模式";
      case 2:
        return "地獄模式";
      default:
        return "$dif";
    }
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        final elapsed = DateTime.now().difference(_startTime).inSeconds;
        _timeLeft = widget.difficulty - elapsed;
        if (_timeLeft <= 0) {
          _timer.cancel();
          _showGameOverDialog();
        }
      });
    });
  }

  void _generateQuestion() {
    final random = Random();
    final elements = [
      {"text": "紅色", "color": Colors.red},
      {"text": "藍色", "color": Colors.blue},
      {"text": "黃色", "color": Colors.yellow},
      {"text": "黑色", "color": Colors.black},
      {"text": "剪刀", "color": Colors.black},
      {"text": "石頭", "color": Colors.black},
      {"text": "布", "color": Colors.black},
    ];
    setState(() {
      final randomElement = elements[random.nextInt(elements.length)];
      _currentElement = randomElement;

      final randomChallenge = random.nextInt(3); // 0: 顏色, 1: 內容, 2: 剪刀石頭布

      final randomRace = random.nextInt(3);

      final randomColor = elements[random.nextInt(4)]["color"] as Color;
      _textColor = randomColor;

      final isColorQuestion = randomChallenge == 0;
      final isContentQuestion = randomChallenge == 1;

      if (isColorQuestion) {
        _question = "文字的顏色是什麼？";
        _options = elements.map((e) => e["text"] as String).toList();
        _correctAnswer =
            elements.firstWhere((e) => e["color"] == _textColor)["text"]
                as String;
      } else if (isContentQuestion) {
        _question = "文字的內容是什麼？";
        _options = elements.map((e) => e["text"] as String).toList();
        _correctAnswer = randomElement["text"] as String;
      } else {
        // 剪刀石頭布問題
        final rpsOptions = ["剪刀", "石頭", "布"];
        final opponent = rpsOptions[random.nextInt(rpsOptions.length)];
        if (randomRace == 0) {
          _question = "贏給 $opponent";
          _correctAnswer = _getWinningMove(opponent);
        } else if (randomRace == 1) {
          _question = "輸給 $opponent";
          _correctAnswer = _getLosingMove(opponent);
        } else {
          _question = "和 $opponent 平手";
          _correctAnswer = opponent;
        }
        _options = rpsOptions;
      }

      // _options.shuffle();
    });
  }

  String _getWinningMove(String opponent) {
    switch (opponent) {
      case "石頭":
        return "布";
      case "布":
        return "剪刀";
      case "剪刀":
        return "石頭";
      default:
        return "";
    }
  }

  String _getLosingMove(String opponent) {
    switch (opponent) {
      case "石頭":
        return "剪刀";
      case "布":
        return "石頭";
      case "剪刀":
        return "布";
      default:
        return "";
    }
  }

  void _checkAnswer(String answer) {
    if (answer == _correctAnswer) {
      _timer.cancel(); // Stop the current timer
      setState(() {
        _score++; // Increment score
        _timeLeft = widget.difficulty; // Reset the timer
      });
      _startGame(); // Generate a new question and restart the timer
    } else {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("遊戲結束"),
            content: Text("您答錯了! 正確答案是 $_correctAnswer\n您累積了 $_score 分！"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Return to HomePage
                },
                child: const Text("返回主頁面"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(_difficultyName(widget.difficulty),style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _timer.cancel();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg2.png"), // 確保在 pubspec.yaml 中正確配置資源
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("目前累積分數：$_score"),
              Text(
                "剩餘時間: $_timeLeft 秒",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _currentElement != null
                    ? _currentElement!["text"] as String
                    : "",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                  shadows: const [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._options.map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 20.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black54,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
