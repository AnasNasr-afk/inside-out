import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:patient/provider/therapy_goals_provider.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import '../../gen/assets.gen.dart';
import '../../model/therapy_models/therapy_models.dart';

class TherapyGoalsScreen extends StatefulWidget {
  const TherapyGoalsScreen({super.key});

  @override
  TherapyGoalsScreenState createState() => TherapyGoalsScreenState();
}

class TherapyGoalsScreenState extends State<TherapyGoalsScreen> {
  int selectedTabIndex =
      0; // 0 for Goals, 1 for Achievements, 2 for Observations
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapyGoalsProvider>().fetchTherapyGoals(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Therapy Goals"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Bar
            EasyDateTimeLinePicker.itemBuilder(
              firstDate: DateTime(2024, 1, 1),
              lastDate: DateTime(2025, 12, 31),
              focusedDate: selectedDate,
              itemExtent: screenWidth * 0.2,
              itemBuilder:
                  (context, date, isSelected, isDisabled, isToday, onTap) {
                return GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 20,
                    width: isToday ? screenWidth * 0.25 : screenWidth * 0.2,
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 30, maxHeight: 40),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF7A86F8) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        isToday ? "Today" : "${date.day}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                });
                context.read<TherapyGoalsProvider>().fetchTherapyGoals(selectedDate);
              },
            ),

            const SizedBox(height: 20),

            // Therapy Card
            
            Consumer<TherapyGoalsProvider>(
              builder: (context, provider, child) {
                if(provider.apiStatus == ApiStatus.initial) {
                  return const SizedBox.shrink();
                }

                if(provider.apiStatus == ApiStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if(provider.apiStatus == ApiStatus.failure) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }

              return Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color.fromARGB(82, 158, 158, 158)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              Assets.placeholders.therapistImg.provider(),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.therapyGoal!.therapistName ?? "Therapist Name",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Text(
                              provider.therapyGoal!.specialization ?? "",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn("Therapy", provider.therapyGoal!.therapyType ?? "Therapy Type"),
                        _buildInfoColumn("Done at", provider.therapyGoal!.performedOn.toString().split(" ")[0]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn("Therapy Mode", provider.therapyGoal?.therapyMode == 1 ? "Online" : "Offline"),
                        _buildInfoColumn("Duration", "${provider.therapyGoal!.duration} mins"),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            // Tab Selection
            Container(
              padding: const EdgeInsets.all(6),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton("Goals", 0),
                  _buildTabButton("Observations", 1),
                  _buildTabButton("Regression", 2),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Content Display
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(250, 250, 250, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildContent(selectedTabIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        decoration: BoxDecoration(
          color: selectedTabIndex == index
              ? const Color(0xFF7A86F8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: selectedTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildContent(int index) {
    final therapyGoal = context.watch<TherapyGoalsProvider>().therapyGoal;

    return Consumer<TherapyGoalsProvider>(builder: (context, provider, child) {
      if(provider.apiStatus == ApiStatus.initial) {
        return const SizedBox.shrink();
      }

      if (provider.apiStatus == ApiStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (provider.apiStatus == ApiStatus.failure) {
        return const Center(
          child: Text('No data available'),
        );
      }

      List<TherapyModel> therapyGoalModel;

      if(index == 0) {
        therapyGoalModel = provider.therapyGoal!.goals;
      } else if (index == 1) {
        therapyGoalModel = provider.therapyGoal!.observations;
      } else {
        therapyGoalModel = provider.therapyGoal!.regressions;
      }

      if(therapyGoal == null || therapyGoalModel.isEmpty) {
        return const Center(
          child: Text('No data available'),
        );
      }

      return ListView.builder(
        itemCount: therapyGoalModel.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${i + 1}. ${therapyGoalModel[i].name}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          );
        },
      );
    });
  }
}
