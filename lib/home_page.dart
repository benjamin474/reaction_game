import 'package:flutter/material.dart';
import 'game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("反應力大考驗",style: TextStyle(color: Colors.white),),
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
      MaterialPageRoute(builder: (context) => GamePage(difficulty: difficulty)),
    );
  }
}
