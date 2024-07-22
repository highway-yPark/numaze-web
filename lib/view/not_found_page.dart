import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';
import '../components/inkwell_button.dart';

class NotFoundPage extends ConsumerStatefulWidget {
  final String shopDomain;

  const NotFoundPage({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends ConsumerState<NotFoundPage> {
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
                      // Image.asset(
                      //   'assets/images/alert.png',
                      //   height: 88,
                      //   width: 88,
                      // ),
                      CommonIcons.alert(),

                      const SizedBox(
                        height: 31,
                      ),
                      Text(
                        '내역이 발견되지 않았어요!',
                        style: TextDesign.bold26B,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '최근 예약 내역이 없어요.\n누메이즈에서 원하는 시술을 만나보세요.',
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
                  text: '예약 하러가기',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
