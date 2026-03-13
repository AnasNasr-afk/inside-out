import 'package:flutter/material.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/model/auth_models/therapist_model.dart';
import 'package:patient/presentation/auth/consultation_slot_booking_screen.dart';

class ConsultationRequestCard extends StatelessWidget {
  const ConsultationRequestCard({
    super.key,
    required this.therapistData,
  });

  final TherapistModel therapistData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE8E8E8))
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffE8E8E8)),
                ),
                child: Assets.placeholders.therapistImg.image(),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    therapistData.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff111847)
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(label: "Phone", value: therapistData.phone),
              _InfoItem(label: "Email", value: therapistData.email),
            ],
          ),
          const SizedBox(height: 12),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(label: "Speciality", value: therapistData.specialisation),
              _InfoItem(label: "Offered Therapies", value: therapistData.offeredTherapies.first),
            ],
          ),
          const SizedBox(height: 17,),
          const Divider(height: 1, color: Color(0xffE1E2E7),),
          const SizedBox(height: 17,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConsultationSlotBookingScreen(therapistId: therapistData.id,)));
            },
            child: const Text(
              "Consult",
              style: TextStyle(
                color: Color(0xffCB6CE6),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xff6D6D6D))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff111847))),
      ],
    );
  }
}
