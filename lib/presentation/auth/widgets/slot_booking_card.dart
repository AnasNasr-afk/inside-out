import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/core/core.dart';
import 'package:patient/presentation/home/home_screen.dart';
import 'package:patient/presentation/widgets/snackbar_service.dart';
import 'package:patient/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SlotBookingCard extends StatefulWidget {
  const SlotBookingCard({
    super.key,
    required this.therpistId
  });

  final String therpistId;

  @override
  State<SlotBookingCard> createState() => _SlotBookingCardState();
}

class _SlotBookingCardState extends State<SlotBookingCard> {
  DateTime? selectedDate;
  int? selectedSlotIndex;


  DateTime getInitialWeekdayDate() {
    DateTime date = DateTime.now();
    while (
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = getInitialWeekdayDate();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime date) {
        return date.weekday != DateTime.saturday &&
            date.weekday != DateTime.sunday;
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedSlotIndex = null;
      });
      _getTherapistAvailableSlots(picked);
    }
  }

  void _getTherapistAvailableSlots(DateTime picked) {  
    context.read<AuthProvider>().getAvailableBookingSlotsForTherapist(widget.therpistId, picked);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<AuthProvider>();
      if (provider.bookConsulationStatus.isSuccess) {
        SnackbarService.showSuccess('Consultation booked successfully');
        await Future.delayed(const Duration(seconds: 2));
        _navigateToHome();
      } else if (provider.bookConsulationStatus.isFailure) {
        SnackbarService.showError('Something went wrong. Please try again later.');
      }
    });
  }

  _navigateToHome() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const HomeScreen(userName: '',),
    ));
  }

  @override
  Widget build(BuildContext context) {
     Provider.of<AuthProvider>(context, listen: true).bookConsulationStatus;
    final selectedDateStr = selectedDate != null
        ? DateFormat('EEEE, MMM d, yyyy').format(selectedDate!)
        : "Select Date";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose a Date",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(selectedDateStr),
            ),
            const SizedBox(height: 16),
            const Text("Select a Slot",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Consumer<AuthProvider>(
              builder: (context, provider, child) {
                if (provider.availableBookingSlotsStatus.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (provider.availableBookingSlotsStatus.isFailure) {
                  return const Center(
                    child: Text('Error while fetching slots'),
                  );
                } else {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(provider.availableBookingSlots.length, (index) {
                      return ChoiceChip(
                        label: Text(provider.availableBookingSlots[index]),
                        selected: selectedSlotIndex == index,
                        onSelected: (_) =>
                            setState(() => selectedSlotIndex = index),
                        selectedColor: Colors.purple.shade100,
                      );
                    }),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: selectedDate != null && selectedSlotIndex != null
                    ? () {
                        context.read<AuthProvider>()
                        .bookConsultation(widget.therpistId, selectedDate!, selectedSlotIndex!);
                      }
                    : null,
                child: const Text("Confirm Slot"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
