import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repository.dart';

class PaymentCompleteScreen extends ConsumerStatefulWidget {
  final String appointmentId;

  const PaymentCompleteScreen({
    super.key,
    required this.appointmentId,
  });

  @override
  ConsumerState<PaymentCompleteScreen> createState() =>
      _PaymentCompleteScreenState();
}

class _PaymentCompleteScreenState extends ConsumerState<PaymentCompleteScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(repositoryProvider).paymentMade(
          appointmentId: widget.appointmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Payment Complete',
        ),
      ),
    );
  }
}
