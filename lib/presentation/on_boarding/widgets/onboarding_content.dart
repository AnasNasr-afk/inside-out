import 'package:patient/gen/assets.gen.dart';

class OnboardingContent {
  final SvgGenImage image;
  final String title;
  final String description;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardingContent> onboardingContents = [
  OnboardingContent(
    image: Assets.illustrations.i9nActivities,
    title: 'Daily Activities',
    description: 'Personalized Daily Activities, Tracked Effortlessly!',
  ),
  OnboardingContent(
    image: Assets.illustrations.i9nGoals,
    title: 'Therapy Goals',
    description: 'Set and achieve your therapy goals with ease!',
  ),
  OnboardingContent(
    image: Assets.illustrations.i9nMilestones,
    title: 'Health Tracking',
    description: 'Monitor your health metrics with ease and accuracy!',
  ),
];