// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../repository.dart';
//
// class PaymentCompleteScreen extends ConsumerStatefulWidget {
//   final String appointmentId;
//
//   const PaymentCompleteScreen({
//     super.key,
//     required this.appointmentId,
//   });
//
//   @override
//   ConsumerState<PaymentCompleteScreen> createState() =>
//       _PaymentCompleteScreenState();
// }
//
// class _PaymentCompleteScreenState extends ConsumerState<PaymentCompleteScreen> {
//   @override
//   void initState() {
//     super.initState();
//     ref.read(repositoryProvider).paymentMade(
//           appointmentId: widget.appointmentId,
//         );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Payment Complete',
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/text.dart';
import '../repository.dart';

class PaymentComplete extends ConsumerStatefulWidget {
  final String appointmentId;

  const PaymentComplete({
    super.key,
    required this.appointmentId,
  });

  @override
  ConsumerState<PaymentComplete> createState() => _PaymentCompleteState();
}

class _PaymentCompleteState extends ConsumerState<PaymentComplete> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Ensure the provider is read only when the widget tree is ready
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       sendRequest();
  //     }
  //   });
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger your action here
    sendRequest();
  }

  void sendRequest() async {
    await ref.read(repositoryProvider).paymentMade(
          appointmentId: widget.appointmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => sendRequest());
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              const SizedBox(
                height: 171,
              ),
              CommonIcons.paymentComplete(),
              Text(
                '예약금 입금 확인을\n샵에게 요청했어요',
                style: TextDesign.bold26B,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '샵에서 예약금을 확인하면\n확정 안내를 도와드릴게요',
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
