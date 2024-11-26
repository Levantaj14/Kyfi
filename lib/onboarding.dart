import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class onBoarding extends StatelessWidget {
  const onBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Animate(
              effects: const [MoveEffect(), FadeEffect()],
              child: const Text('Isten hozott!',
                style: TextStyle(
                    fontSize: 25
                ),),
            ),
            Image.asset(
                'assets/images/welcome.png',
              scale: 3,
            ),
            ElevatedButton(onPressed: (){}, child: const Text("oh, ez mit csinal?"))
          ],
        )
      ),
    );
  }
}
