import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, int> _highScores = {};

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  void _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScores = {
        10: prefs.getInt('highScore_10') ?? 0,
        5: prefs.getInt('highScore_5') ?? 0,
        3: prefs.getInt('highScore_3') ?? 0,
        2: prefs.getInt('highScore_2') ?? 0,
      };
    });
  }

  void _updateHighScore(int difficulty, int newHighScore) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore_$difficulty', newHighScore);
    setState(() {
      _highScores[difficulty] = newHighScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("反應力大考驗", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "選擇難度",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              for (var entry in _highScores.entries)
                Text(
                  "${_difficultyName(entry.key)}: ${entry.value} 分",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToGame(context, 10),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text("簡單 (10秒)", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToGame(context, 5),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text("普通 (5秒)", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToGame(context, 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text("困難 (3秒)", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _navigateToGame(context, 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text("地獄 (1.5秒)", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context, int difficulty) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamePage(
          difficulty: difficulty,
          onHighScoreUpdated: (newHighScore) {
            _updateHighScore(difficulty, newHighScore);
          },
        ),
      ),
    );
  }

  String _difficultyName(int difficulty) {
    switch (difficulty) {
      case 10:
        return "簡單模式";
      case 5:
        return "普通模式";
      case 3:
        return "困難模式";
      case 2:
        return "地獄模式";
      default:
        return "未知模式";
    }
  }
}
