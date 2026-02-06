import 'package:cookly/feature/Account/widgets/profile_header.dart';
import 'package:cookly/feature/Account/widgets/settings_list.dart';
import 'package:cookly/feature/Account/widgets/stats_row.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E2),
      body: SafeArea(
        child: Column(
          children: [
            profileHeader(),
            const SizedBox(height: 20),
            statRow(),
            const SizedBox(height: 20),

            Expanded(child: SingleChildScrollView(child: settingsList(context))),
          ],
        ),
      ),
    );
  }
}
