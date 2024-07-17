import 'package:flutter/material.dart';

import '../const/text.dart';

class CommonTitle extends StatelessWidget {
  final String title;
  const CommonTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextDesign.bold18B,
    );
  }
}
