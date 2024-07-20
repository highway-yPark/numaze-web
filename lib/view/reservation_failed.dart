import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/components/inkwell_button.dart';
import '../common/const/text.dart';

class ReservationFailed extends ConsumerStatefulWidget {
  final String shopDomain;

  const ReservationFailed({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<ReservationFailed> createState() => _ReservationFailedState();
}

class _ReservationFailedState extends ConsumerState<ReservationFailed> {
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
                      Image.asset(
                        'assets/images/alert.png',
                        height: 88,
                        width: 88,
                      ),
                      const SizedBox(
                        height: 31,
                      ),
                      Text(
                        '예약을 진행하는 도중\n선택한 시간이 마감되었어요.',
                        style: TextDesign.bold26B,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '홈으로 돌아가 다시 예약을 진행해주세요.',
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
