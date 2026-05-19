import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonRow extends StatelessWidget {
  final String? initials;
  final IconData? icon;
  final Color avatarColor;
  final Color avatarTextColor;
  final String name;
  final String subtitle;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const PersonRow({super.key,
    this.initials,
    this.icon,
    required this.avatarColor,
    required this.avatarTextColor,
    required this.name,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarColor,
            child: icon != null
                ? Icon(icon, color: avatarTextColor, size: 22)
                : Text(initials ?? '',
                style: TextStyle(
                    color: avatarTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF6B7280))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(badgeLabel,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeTextColor)),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            child: Text(label,
                style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF9CA3AF))),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF374151)),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
  return '?';
}