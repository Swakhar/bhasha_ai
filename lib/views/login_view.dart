import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/app_logo_mark.dart';
import '../widgets/primary_card.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.auth});

  final AuthService auth;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  bool _otpSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('একটি বৈধ ইমেইল দিন।');
      }
      await widget.auth.sendEmailOtp(email: email);
      if (!mounted) return;
      setState(() => _otpSent = true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final email = _emailCtrl.text.trim();
      final token = _otpCtrl.text.trim();
      if (token.length < 6) {
        throw Exception('OTP কোডটি দিন (৬ অঙ্ক)।');
      }
      await widget.auth.verifyEmailOtp(email: email, token: token);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final maxWidth = w < 520 ? w : 520.0;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: AppLogoMark(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bhasha AI',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  _otpSent ? 'আপনার ইমেইলে OTP পাঠানো হয়েছে' : 'ইমেইল দিয়ে দ্রুত সাইন-ইন করুন',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                const SizedBox(height: 18),
                PrimaryCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        enabled: !_busy && !_otpSent,
                        decoration: const InputDecoration(
                          labelText: 'ইমেইল',
                          hintText: 'আপনার ইমেইল লিখুন',
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 220),
                        crossFadeState: _otpSent
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: FilledButton(
                          onPressed: _busy ? null : _sendOtp,
                          child: Text(_busy ? 'পাঠানো হচ্ছে…' : 'OTP পাঠান'),
                        ),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _otpCtrl,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              enabled: !_busy,
                              decoration: const InputDecoration(
                                labelText: 'OTP',
                                hintText: '৬ অঙ্কের কোড',
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _busy ? null : _verifyOtp,
                              child: Text(_busy ? 'যাচাই হচ্ছে…' : 'সাইন ইন'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: _busy
                                  ? null
                                  : () => setState(() {
                                        _otpSent = false;
                                        _otpCtrl.clear();
                                        _error = null;
                                      }),
                              child: const Text('ইমেইল পরিবর্তন করুন'),
                            ),
                          ],
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          _error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'বাংলা লেখা ঠিকমতো দেখানোর জন্য Noto Sans Bengali ফন্ট ব্যবহার করা হচ্ছে।',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

