import 'package:flutter/material.dart';

import '../../model/model.dart';
import 'common_image.dart';

class GridItem extends StatelessWidget {
  final StyleModel style;

  const GridItem({
    super.key,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonImage(
          imageUrl: style.thumbnail,
          width: (MediaQuery.sizeOf(context).width - 6) / 3,
          height: (MediaQuery.sizeOf(context).width - 6) / 3,
        ),
      ],
    );
  }
}
