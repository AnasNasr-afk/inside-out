import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  int? _openIndex;

  static const _faqs = [
    (
      q: 'What is Inside Out?',
      a: 'Inside Out is a therapy companion app that helps children with autism, Down syndrome, or speech difficulties practice their specialist-assigned tasks through Poly, an AI bear that listens and guides them.',
    ),
    (
      q: 'Who is Poly?',
      a: 'Poly is a warm AI companion bear. Children can talk to Poly about their therapy tasks, get simple tips, and practice in a safe and encouraging environment.',
    ),
    (
      q: 'How do tasks work?',
      a: 'Your child\'s specialist assigns tasks through the app. You can see them on the Tasks screen. Your child can talk to Poly about any task using the spin wheel on the AI Avatar screen.',
    ),
    (
      q: 'What are session reports?',
      a: 'After your child talks to Poly about their tasks, a session report is automatically generated and sent to your specialist. You can view past reports on the Reports screen.',
    ),
    (
      q: 'What languages does Poly support?',
      a: 'Poly currently supports English, Arabic (Egyptian dialect), and Japanese. You can switch languages using the flag button on the AI Avatar screen.',
    ),
    (
      q: 'Is my child\'s data private?',
      a: 'Yes. All session data is encrypted and only shared with your linked specialist. We do not sell or share personal data with third parties.',
    ),
    (
      q: 'What should I do if the app is not working?',
      a: 'Try closing and reopening the app. If the issue continues, check your internet connection. You can also contact support from the Profile screen.',
    ),
    (
      q: 'How do I log out?',
      a: 'Go to the Profile screen and tap "Log Out" at the bottom. You will be asked to confirm before logging out.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Row(
              children: [
                const Icon(Icons.help_outline_rounded,
                    color: Color(0xFF0369A1), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap a question to expand the answer.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_faqs.length, (i) {
            final faq = _faqs[i];
            final isOpen = _openIndex == i;
            return Column(
              children: [
                InkWell(
                  onTap: () =>
                      setState(() => _openIndex = isOpen ? null : i),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            faq.q,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      faq.a,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                  ),
                  crossFadeState: isOpen
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
              ],
            );
          }),
        ],
      ),
    );
  }
}
