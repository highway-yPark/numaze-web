// import 'package:flutter/material.dart';
//
// import '../const/colors.dart';
// import '../const/widgets.dart';
// import 'inkwell_button.dart';
//
// class CustomCta extends StatelessWidget {
//   final VoidCallback onTap;
//   final String text;
//   final Color color;
//   final Color fontColor;
//
//   const CustomCta({
//     super.key,
//     required this.onTap,
//     required this.text,
//     required this.color,
//     required this.fontColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         CommonWidgets.customDivider(StrokeColors.ctaGrey),
//         Container(
//           color: ContainerColors.white,
//           padding: CommonWidgets.ctaPadding(),
//           child: SizedBox(
//             height: 52,
//             width: MediaQuery.sizeOf(context).width,
//             child: InkwellButton(
//               onTap: onTap,
//               text: text,
//               color: color,
//               fontColor: fontColor,
//               isCta: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // i want to extend custom cta with color black and fontcolor white
// class CustomBlackCta extends CustomCta {
//   const CustomBlackCta({
//     super.key,
//     required super.onTap,
//     required super.text,
//   }) : super(
//           color: ContainerColors.black,
//           fontColor: FontColors.white,
//         );
// }
//
// class ConditionalCta extends CustomCta {
//   final bool condition;
//
//   const ConditionalCta({
//     super.key,
//     required this.condition,
//     required super.onTap,
//     required super.text,
//   }) : super(
//           color: condition ? ContainerColors.ctaGrey : ContainerColors.black,
//           fontColor: FontColors.white,
//         );
// }
