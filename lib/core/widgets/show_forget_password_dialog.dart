import 'package:cookly/core/widgets/textfield.dart';
import 'package:cookly/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showForgotPasswordDialog(BuildContext context, ) {
  final resetEmailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFf4f1e2),
      title: const Text("Reset Password", style: TextStyle(color: Color(0xFF09338c))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter your email and we'll send you a password reset link."),
          const SizedBox(height: 15),
          Textfield(
            controller: resetEmailController,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFe6604b)),
          onPressed: () {
            final email = resetEmailController.text.trim();
            if (email.isNotEmpty) {
              Navigator.pop(context); // Close dialog
              context.read<AuthCubit>().resetPassword(email: email);
              
              // Show a confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Reset link sent to $email")),
              );
            }
          },
          child: const Text("Send Link", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}