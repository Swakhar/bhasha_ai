import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_palette.dart';
import '../widgets/primary_card.dart';
import 'chat_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.auth});

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    final email = auth.user?.email ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.text,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: auth.signOut,
            child: const Text('Sign out'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'স্বাগতম',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'আপনি সফলভাবে লগইন করেছেন।',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ChatScreen(),
                ),
              );
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('শেখার জায়গায় যান (চ্যাট)'),
          ),
          const SizedBox(height: 18),
          PrimaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.alternate_email, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(email)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          PrimaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unicode check',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'বাংলা • বাংলা ভাষা • ভাষা AI — সবকিছু ঠিকঠাক রেন্ডার হওয়া উচিত।',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

