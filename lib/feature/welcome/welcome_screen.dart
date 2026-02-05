import 'package:cookly/feature/auth/presentation/ui/login/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5eede),
      body: Container(
        margin: const EdgeInsets.only(top: 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/onboarding.png"),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "30K+ PREMIUM RECIPES",
                style: TextStyle(
                  color: Color(0xff022175),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "It's \nCooking Time!",
                style: TextStyle(
                  color: Color(0xff022175),
                  fontSize: 50.0,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFe4614a),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: 70,
                  width: 350,
                  child: const Center(
                    child: Text(
                      "Start Cooking!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}