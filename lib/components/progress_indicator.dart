import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:numaze_web/common/const/text.dart';

class StatusColumn extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? message;
  final int currentStep;
  final bool noIndicator;
  const StatusColumn({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    required this.currentStep,
    this.noIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        icon,
        const SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: TextDesign.bold26B,
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              '반드시 하단의 안내 사항을 모두 읽어주세요',
              style: TextDesign.medium16BO,
            ),
          ),
        const SizedBox(
          height: 40,
        ),
        if (!noIndicator)
          Column(
            children: [
              ProgressIndicator(
                currentStep: currentStep,
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
      ],
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  final int currentStep;

  const ProgressIndicator({
    super.key,
    required this.currentStep,
  }); // Update this to change the active step

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 296,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StepIndicator(
                isActive: currentStep >= 0,
                filled: currentStep > 0,
              ),
              StepConnector(isActive: currentStep > 0),
              StepIndicator(
                isActive: currentStep >= 1,
                filled: currentStep > 1,
              ),
              StepConnector(isActive: currentStep > 1),
              StepIndicator(
                isActive: currentStep >= 2,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 9,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '대기',
                style:
                    currentStep > 0 ? TextDesign.bold12BO : TextDesign.bold12B,
              ),
              Text(
                '확정',
                style: currentStep > 1
                    ? TextDesign.bold12BO
                    : currentStep == 1
                        ? TextDesign.bold12B
                        : TextDesign.bold12MG,
              ),
              Text(
                '방문',
                style:
                    currentStep == 2 ? TextDesign.bold12B : TextDesign.bold12MG,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final bool isActive;
  final bool filled;

  const StepIndicator({
    super.key,
    required this.isActive,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? BrandColors.orange : StrokeColors.grey,
              width: 2,
            ),
            color: filled ? BrandColors.orange : Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? BrandColors.orange : StrokeColors.white,
            ),
            margin: const EdgeInsets.all(1.5),
          ),
        ),
      ],
    );
  }
}

class StepConnector extends StatelessWidget {
  final bool isActive;

  const StepConnector({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 121,
      height: 2,
      color: isActive ? BrandColors.orange : StrokeColors.grey,
    );
  }
}
