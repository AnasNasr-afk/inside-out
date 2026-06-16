import 'package:flutter/material.dart';
import 'package:patient/core/helpers/shared_pref.dart';
import 'package:patient/core/helpers/shared_pref_keys.dart';
import 'package:patient/core/theme/app_tokens.dart';
import 'package:patient/presentation/child_mood/poly_world_transition.dart';

class ChildModeButton extends StatelessWidget {
  const ChildModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SharedPrefHelper.getString('userId');
    final frontendId = SharedPrefHelper.getInt('frontendId');
    final rawName = SharedPrefHelper.getString(SharedPrefKeys.childName);
    final childName = rawName.split(' ').first.toUpperCase();

    return GestureDetector(
      onTap: () {
        if (userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in again.')),
          );
          return;
        }
        PolyWorldTransition.show(
          context,
          childName: childName.isNotEmpty ? childName : 'FRIEND',
          frontendId: frontendId.toString(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: T.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: T.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: T.primary.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/illustrations/childModeIcon.png',
                width: 52,
                height: 52,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Child Mode',
                    style: T.cardTitle().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'A calmer, simpler space for kids',
                    style: T.caption().copyWith(color: T.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 46,
              height: 27,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
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
