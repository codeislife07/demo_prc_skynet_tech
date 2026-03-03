import 'package:flutter/material.dart';
import 'package:demo_prc_skynet_tech/features/home/presentation/screen/home_list_screen.dart';

class AuthHomeScreen extends StatelessWidget {
  final String userEmail;

  const AuthHomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return HomeListScreen(userEmail: userEmail);
  }
}
