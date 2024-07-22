import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';
import '../components/inkwell_button.dart';

class EmptyTreatmentPage extends ConsumerStatefulWidget {
  final String shopDomain;

  const EmptyTreatmentPage({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<EmptyTreatmentPage> createState() => _EmptyTreatmentPageState();
}

class _EmptyTreatmentPageState extends ConsumerState<EmptyTreatmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 202,
                      ),
                      CommonIcons.emptyTreatment(),
                      const SizedBox(
                        height: 31,
                      ),
                      Text(
                        '선택한 시술 정보를\n찾을 수 없어요',
                        style: TextDesign.bold26B,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '페이지를 새로고침 하거나 접속시간이 만료되면,\n시술을 다시 선택해야 돼요.',
                        style: TextDesign.medium16MG,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // if (bottomInset == 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlackInkwellButton(
                  onTap: () async {
                    context.go('/s/${widget.shopDomain}');
                  },
                  text: '홈으로 돌아가기',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
