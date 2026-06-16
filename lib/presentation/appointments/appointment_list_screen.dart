import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({super.key});

  // Day of week + time is enough for a recurring weekly schedule
  final List<Map<String, dynamic>> _appointments = const [
    {
      'id': 1,
      'serviceType': 'Speech Therapy',
      'day': 'Every Monday',
      'time': '10:00 AM',
      'icon': Icons.record_voice_over_outlined,
    },
    {
      'id': 2,
      'serviceType': 'Behavioral Session',
      'day': 'Every Wednesday',
      'time': '2:30 PM',
      'icon': Icons.psychology_outlined,
    },
    {
      'id': 3,
      'serviceType': 'Consultation',
      'day': 'Every Friday',
      'time': '12:00 PM',
      'icon': Icons.chat_bubble_outline_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isEmpty = _appointments.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 18.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointments',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: false,
        // ── Schedule button lives here — one entry point only ────────────
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                // TODO: navigate to create screen
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 7.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '+ New',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isEmpty
            ? _buildEmptyState(context)
            : _buildList(context),
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 40.sp,
              color: Color(0xFF6366F1),
            ),
          ),

          SizedBox(height: 20.h),

          Text(
            'No Appointments Yet',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            'Your recurring therapy sessions\nwill appear here.',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
              height: 1.5.h,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Appointments List ────────────────────────────────────────────────────
  Widget _buildList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      itemCount: _appointments.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final apt = _appointments[index];
        return _AppointmentCard(appointment: apt);
      },
    );
  }
}

// ── Appointment Card ──────────────────────────────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(appointment['id']),
      direction: DismissDirection.endToStart,
      background: _dismissBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon container ─────────────────────────────────────────
            Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                appointment['icon'] as IconData,
                size: 22.sp,
                color: const Color(0xFF6366F1),
              ),
            ),

            SizedBox(width: 14.w),

            // ── Text ───────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment['serviceType'],
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.repeat_rounded,
                        size: 13.sp,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${appointment['day']}  ·  ${appointment['time']}',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Recurring badge ────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Weekly',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Swipe to delete background ───────────────────────────────────────────
  Widget _dismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E4),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Icon(
        Icons.delete_outline_rounded,
        color: Color(0xFFEF4444),
        size: 24.sp,
      ),
    );
  }

  // ── Confirm delete dialog ────────────────────────────────────────────────
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Remove Appointment?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: const Color(0xFF1F2937),
          ),
        ),
        content: Text(
          'This will remove "${appointment['serviceType']}" from your schedule.',
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Remove',
              style: GoogleFonts.poppins(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}