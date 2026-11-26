import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/studylog_charts.dart';

class StudyLogLoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const StudyLogLoginPage({super.key, required this.onLoginSuccess});

  @override
  State<StudyLogLoginPage> createState() => _StudyLogLoginPageState();
}

class _StudyLogLoginPageState extends State<StudyLogLoginPage> {
  final _nimController = TextEditingController(text: '2411093');
  final _passController = TextEditingController(text: '••••••••');
  bool _obscure = true;

  @override
  void dispose() {
    _nimController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudyLogColors.background,
      body: CampusWatermarkBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CampusLogoBadge(
                      size: 68,
                      borderRadius: 18,
                      padding: 6,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'STUDYLOG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.2,
                        color: StudyLogColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Portal Mahasiswa · Universitas Mulia',
                      style: TextStyle(
                        fontSize: 13,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 26),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: StudyLogColors.textPrimary,
                        ),
                        children: [
                          TextSpan(text: 'Masuk ke '),
                          TextSpan(
                            text: 'Portal.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: StudyLogColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: StudyLogColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: StudyLogColors.borderSubtle),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NIM MAHASISWA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nimController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan NIM',
                              filled: true,
                              fillColor: StudyLogColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'KATA SANDI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: StudyLogColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Kata Sandi',
                              filled: true,
                              fillColor: StudyLogColors.background,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: StudyLogColors.borderSubtle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: StudyLogColors.orangeBright,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: widget.onLoginSuccess,
                              child: const Text(
                                'Masuk ke Beranda',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
