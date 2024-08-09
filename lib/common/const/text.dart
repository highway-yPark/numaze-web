import 'package:flutter/material.dart';

import 'colors.dart';

// class TextDesign {
//   static const TextStyle bold16 = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w700,
//   );
//
//   static const TextStyle regular12 = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//   );
//
//   static const TextStyle regular14 = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//   );
//
//   static const TextStyle regular16 = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//   );
//
//   static const TextStyle bold14 = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//   );
//
//   static const TextStyle bold18 = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w700,
//   );
//
//   static const TextStyle medium14 = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//   );
//
//   static const TextStyle medium10 = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.w500,
//   );
//
//   static const TextStyle medium16 = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//   );
//
//   static const TextStyle bold26 = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w700,
//   );
//
//   static const TextStyle bold12 = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//   );
// }

class TextDesign {
  // Base styles
  static const TextStyle baseBold = TextStyle(
    fontWeight: FontWeight.w700,
  );

  static const TextStyle baseRegular = TextStyle(
    fontWeight: FontWeight.w400,
  );

  static const TextStyle baseMedium = TextStyle(
    fontWeight: FontWeight.w500,
  );

  static const TextStyle baseSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static const TextStyle baseExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
  );
  // Text styles with different colors
  static TextStyle bold16MG = baseBold.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.mediumGrey);

  static TextStyle bold16W =
      baseBold.copyWith(fontSize: 16, height: 1.5625, color: FontColors.white);

  static TextStyle bold20W =
      baseBold.copyWith(fontSize: 20, height: 1.25, color: FontColors.white);

  static TextStyle bold20B =
      baseBold.copyWith(fontSize: 20, height: 1.25, color: FontColors.black);

  static TextStyle bold20BO =
      baseBold.copyWith(fontSize: 20, height: 1.25, color: BrandColors.pink);

  static TextStyle medium16MG = baseMedium.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.mediumGrey);

  static TextStyle medium16G =
      baseMedium.copyWith(fontSize: 16, height: 1.5625, color: FontColors.grey);

  static TextStyle medium16B = baseMedium.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.black);

  static TextStyle medium16W = baseMedium.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.white);

  static TextStyle medium12G =
      baseMedium.copyWith(fontSize: 12, height: 1.25, color: FontColors.grey);

  static TextStyle medium12BO =
      baseMedium.copyWith(fontSize: 12, height: 1.25, color: BrandColors.pink);

  static TextStyle medium12MG = baseMedium.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.mediumGrey);

  static TextStyle medium12MDG = baseMedium.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.mediumDarkGrey);

  static TextStyle bold22B =
      baseBold.copyWith(fontSize: 22, color: FontColors.black);

  static TextStyle bold16MDG = baseBold.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.mediumDarkGrey);

  static TextStyle regular12G =
      baseRegular.copyWith(fontSize: 12, height: 1.25, color: FontColors.grey);

  static TextStyle regular12W =
      baseRegular.copyWith(fontSize: 12, height: 1.25, color: FontColors.white);

  static TextStyle regular12B =
      baseRegular.copyWith(fontSize: 12, height: 1.25, color: FontColors.black);

  static TextStyle regular12MDG = baseRegular.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.mediumDarkGrey);

  static TextStyle regular12BO =
      baseRegular.copyWith(fontSize: 12, height: 1.25, color: BrandColors.pink);

  static TextStyle regular16B = baseRegular.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.black);

  static TextStyle regular22B = baseRegular.copyWith(
      fontSize: 16, height: 1.273, color: FontColors.black);

  static TextStyle regular16W = baseRegular.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.white);

  static TextStyle regular16MG = baseRegular.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.mediumGrey);

  static TextStyle regular16G = baseRegular.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.grey);

  static TextStyle regular14MG = baseRegular.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.mediumGrey);

  static TextStyle regular14BO =
      baseRegular.copyWith(fontSize: 14, height: 1.43, color: BrandColors.pink);

  static TextStyle regular14G =
      baseRegular.copyWith(fontSize: 14, height: 1.43, color: FontColors.grey);

  static TextStyle regular14MDG = baseRegular.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.mediumDarkGrey);

  static TextStyle regular14B =
      baseRegular.copyWith(fontSize: 14, height: 1.43, color: FontColors.black);

  static TextStyle regular16BO = baseRegular.copyWith(
      fontSize: 16, height: 1.5625, color: BrandColors.pink);

  static TextStyle medium14G =
      baseMedium.copyWith(fontSize: 14, height: 1.43, color: FontColors.grey);

  static TextStyle medium14CG = baseMedium.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.calendarGrey);

  static TextStyle medium14BO =
      baseMedium.copyWith(fontSize: 14, height: 1.43, color: BrandColors.pink);

  static TextStyle medium14B =
      baseMedium.copyWith(fontSize: 14, height: 1.43, color: FontColors.black);

  static TextStyle medium14W = baseMedium.copyWith(
      fontSize: 14, height: 1.43, wordSpacing: 1, color: FontColors.white);

  static TextStyle medium14MG = baseMedium.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.mediumGrey);

  static TextStyle medium14MDG = baseMedium.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.mediumDarkGrey);

  static TextStyle semiBold12G =
      baseSemiBold.copyWith(fontSize: 12, color: FontColors.grey);

  static TextStyle bold12B = baseSemiBold.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.black);

  static TextStyle bold12MG = baseSemiBold.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.mediumGrey);

  static TextStyle bold12W =
      baseBold.copyWith(fontSize: 12, height: 1.25, color: FontColors.white);

  static TextStyle bold12BO =
      baseBold.copyWith(fontSize: 12, height: 1.25, color: BrandColors.pink);

  static TextStyle semiBold14B =
      baseSemiBold.copyWith(fontSize: 14, color: FontColors.black);

  static TextStyle semiBold16B = baseSemiBold.copyWith(
      fontSize: 16, height: 1.5625, color: FontColors.black);

  static TextStyle medium16BO = baseMedium.copyWith(
      fontSize: 16, height: 1.5625, color: BrandColors.pink);

  static TextStyle bold16BO =
      baseBold.copyWith(fontSize: 16, height: 1.5626, color: BrandColors.pink);

  static TextStyle extraBold12DG =
      baseExtraBold.copyWith(fontSize: 12, color: FontColors.darkGrey);

  static TextStyle extraBold12G =
      baseExtraBold.copyWith(fontSize: 12, color: FontColors.grey);

  static TextStyle regular12DG = baseRegular.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.darkGrey);

  static TextStyle regular12MG = baseRegular.copyWith(
      fontSize: 12, height: 1.25, color: FontColors.mediumGrey);

  static TextStyle bold18B =
      baseBold.copyWith(fontSize: 18, height: 1.389, color: FontColors.black);

  static TextStyle bold18BO =
      baseBold.copyWith(fontSize: 18, height: 1.389, color: BrandColors.pink);

  static TextStyle bold18W =
      baseBold.copyWith(fontSize: 18, height: 1.389, color: FontColors.white);

  static TextStyle bold18G =
      baseBold.copyWith(fontSize: 18, height: 1.389, color: FontColors.grey);

  static TextStyle bold16B =
      baseBold.copyWith(fontSize: 16, height: 1.5625, color: FontColors.black);

  static TextStyle bold26B =
      baseBold.copyWith(fontSize: 26, height: 1.154, color: FontColors.black);

  static TextStyle bold14G =
      baseBold.copyWith(fontSize: 14, height: 1.43, color: FontColors.grey);

  static TextStyle bold14B =
      baseBold.copyWith(fontSize: 14, height: 1.43, color: FontColors.black);

  static TextStyle bold14CG = baseBold.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.calendarGrey);

  static TextStyle bold14BO =
      baseBold.copyWith(fontSize: 14, height: 1.43, color: BrandColors.pink);

  static TextStyle bold14MDG = baseBold.copyWith(
      fontSize: 14, height: 1.43, color: FontColors.mediumDarkGrey);

  static TextStyle bold14W =
      baseBold.copyWith(fontSize: 14, height: 1.43, color: FontColors.white);

  // static const TextStyle bold16Secondary = baseBold.copyWith(
  //   fontSize: 16,
  //   color: AppColors.textSecondary,
  // );
  //
  // static const TextStyle bold16Accent = baseBold.copyWith(
  //   fontSize: 16,
  //   color: AppColors.accent,
  // );
  //
  // static const TextStyle regular14Primary = baseRegular.copyWith(
  //   fontSize: 14,
  //   color: AppColors.textPrimary,
  // );
  //
  // static const TextStyle regular14Secondary = baseRegular.copyWith(
  //   fontSize: 14,
  //   color: AppColors.textSecondary,
  // );
  //
  // static const TextStyle regular14Accent = baseRegular.copyWith(
  //   fontSize: 14,
  //   color: AppColors.accent,
  // );
  //
  // static const TextStyle medium12Primary = baseMedium.copyWith(
  //   fontSize: 12,
  //   color: AppColors.textPrimary,
  // );
  //
  // static const TextStyle medium12Secondary = baseMedium.copyWith(
  //   fontSize: 12,
  //   color: AppColors.textSecondary,
  // );
  //
  // static const TextStyle medium12Accent = baseMedium.copyWith(
  //   fontSize: 12,
  //   color: AppColors.accent,
  // );

// Add more text styles as needed
}
