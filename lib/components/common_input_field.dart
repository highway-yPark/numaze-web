import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';

class CommonInputField extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool isPhoneNumber;
  final int? maxLength;
  final TextEditingController? controller;
  final bool isCentered;

  const CommonInputField({
    this.onChanged,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.initialValue,
    this.isPhoneNumber = false,
    this.maxLength,
    this.controller,
    this.isCentered = false,
    super.key,
  });

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 44,
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        maxLengthEnforcement:
            MaxLengthEnforcement.enforced, // Enforce max length
        maxLength: widget.maxLength,
        scrollPadding: const EdgeInsets.all(50),
        initialValue: widget.controller == null ? widget.initialValue : null,
        maxLines: 1,
        cursorColor: FontColors.black,
        onChanged: widget.onChanged,
        onTapOutside: (_) {
          _focusNode.unfocus();
          FocusScope.of(context).unfocus();
        },
        textAlign: widget.isCentered ? TextAlign.center : TextAlign.start,
        style: TextDesign.medium14B,
        keyboardType:
            widget.isPhoneNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: widget.isPhoneNumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          hintText: widget.hintText,
          hintStyle: TextDesign.medium14G,
          fillColor: ContainerColors.white,
          filled: true,
          counterText: '',
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: StrokeColors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: StrokeColors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
