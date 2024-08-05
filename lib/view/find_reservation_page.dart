import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/provider/customer_appointment_provider.dart';
import 'package:numaze_web/repository.dart';

import '../common/const/text.dart';
import '../common/const/widgets.dart';
import '../components/common_input_field.dart';
import '../components/inkwell_button.dart';

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

  bool checkController() {
    return _controller.text.trim().length != 11;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 171),
                          CommonIcons.findReservation(),
                          // const SizedBox(height: 12),
                          Text(
                            '이미 예약한\n시술이 있나요?',
                            style: TextDesign.bold26B,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: CommonWidgets.sixteenTenPadding(),
                            child: CommonInputField(
                              controller: _controller,
                              hintText: '휴대폰 번호를 입력해주세요',
                              isCentered: true,
                              isPhoneNumber: false,
                              maxLength: 11,
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            context.go('/s/${widget.shopDomain}');
                          },
                          child: CommonIcons.home(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (bottomInset == 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ConditionalInkwellButton(
                    onTap: () async {
                      if (checkController()) return;

                      try {
                        final appointmentId = await ref
                            .read(repositoryProvider)
                            .getLatestAppointment(
                              shopDomain: widget.shopDomain,
                              phoneNumber: _controller.text,
                            );
                        final resp = await ref
                            .read(
                                customerAppointmentProvider(appointmentId.data)
                                    .notifier)
                            .getCustomerAppointment();
                        if (!context.mounted) return;
                        if (resp == 200) {
                          context.go(
                              '/appointment/${appointmentId.data}?shopDomain=${widget.shopDomain}');
                        } else {
                          context
                              .go('/notFound?shopDomain=${widget.shopDomain}');
                        }
                      } catch (e) {
                        context.go('/notFound?shopDomain=${widget.shopDomain}');
                      }
                    },
                    text: '조회하기',
                    condition: checkController(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
