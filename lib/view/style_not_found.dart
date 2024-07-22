import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';

class StyleNotFound extends StatelessWidget {
  const StyleNotFound({
    super.key,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              const SizedBox(
                height: 202,
              ),
              CommonIcons.alert(),
              const SizedBox(
                height: 31,
              ),
              // Text(
              //   '원하시는 페이지를\n찾을 수 없어요',
              //   style: TextDesign.bold26B,
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              Text(
                '아직 등록된 스타일이 없어요.',
                style: TextDesign.medium16MG,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
