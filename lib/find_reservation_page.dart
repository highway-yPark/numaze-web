import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/customer_appointment_provider.dart';

import 'common/components/inkwell_button.dart';
import 'common/const/colors.dart';
import 'common/const/text.dart';

class FindReservationPage extends ConsumerStatefulWidget {
  final String shopDomain;

  const FindReservationPage({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<FindReservationPage> createState() =>
      _FindReservationPageState();
}

class _FindReservationPageState extends ConsumerState<FindReservationPage> {
  final TextEditingController _controller = TextEditingController();
  bool notFound = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    // padding: EdgeInsets.only(bottom: bottomInset),
                    child: !notFound
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 171),
                              Icon(Icons.search),
                              SizedBox(height: 12),
                              Text(
                                '예약 내역을 조회해보세요.',
                                style: TextDesign.bold26B,
                              ),
                              SizedBox(height: 40),
                              TextFormField(
                                controller: _controller,
                                scrollPadding:
                                    const EdgeInsets.only(bottom: 100),
                                maxLines: 1,
                                style: TextDesign.medium14G,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ContainerColors.mediumGrey,
                                  hintText: '예약 코드를 입력해주세요',
                                  hintStyle: TextDesign.medium14G,
                                  border: InputBorder.none,
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                                cursorColor: StrokeColors.black,
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 171),
                              Icon(Icons.close),
                              SizedBox(height: 12),
                              Text(
                                '내역이 발견되지 않았어요!',
                                style: TextDesign.bold26B,
                              ),
                              SizedBox(height: 12),
                              Text(
                                '최근 예약 내역이 없어요.\n누메이즈에서 원하는 시술을 만나보세요.',
                                style: TextDesign.medium16G,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
              ),
              if (bottomInset == 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 57,
                    child: BlackInkwellButton(
                        onTap: () async {
                          if (!notFound) {
                            final resp = await ref
                                .read(customerAppointmentProvider(
                                        _controller.text)
                                    .notifier)
                                .getCustomerAppointment();
                            if (!context.mounted) return;
                            if (resp == 200) {
                              context.go(
                                  '/appointment/${_controller.text}?shopDomain=${widget.shopDomain}');
                            } else {
                              setState(() {
                                notFound = true;
                              });
                            }
                          } else {
                            context.go('/s/${widget.shopDomain}');
                          }
                        },
                        text: !notFound ? '조회하기' : '예약하러 가기'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
