import 'package:flutter/material.dart';

import '../common/const/text.dart';

class TextWithNumber extends StatelessWidget {
  final String number;
  final RichText text;
  const TextWithNumber({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          number,
          style: TextDesign.bold14BO,
        ),
        const SizedBox(
          width: 10,
        ),
        text,
      ],
    );
  }
}
