import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';
import '../components/inkwell_button.dart';

class ShopClosePage extends ConsumerStatefulWidget {
  final String shopDomain;

  const ShopClosePage({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<ShopClosePage> createState() => _ShopClosePageState();
}

class _ShopClosePageState extends ConsumerState<ShopClosePage> {
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
                      // CommonIcons.alert(),
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
                        '지금은 예약을\n접수 받을 수 없어요',
                        style: TextDesign.bold26B,
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
