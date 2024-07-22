import 'package:flutter/material.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
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
              Text(
                '원하시는 페이지를\n찾을 수 없어요',
                style: TextDesign.bold26B,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '찾으려는 페이지의 주소가 잘못 되었거나,\n주소의 변경 혹은 삭제로 인해 사용할 수 없어요.\n입력하신 페이지의 주소가 정확한지 확인해주세요.',
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
