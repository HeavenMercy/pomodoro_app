import 'package:flutter/material.dart';

typedef NumberInputFieldCallback = void Function(int value);

class NumberInputField extends StatefulWidget {
  const NumberInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value = 0,
    this.padding,
    this.readOnly = false,
  });

  final String label;
  final NumberInputFieldCallback onChanged;

  final EdgeInsets? padding;
  final bool readOnly;
  final int value;

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  var ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ctrl.text = widget.value.toString();
    if (widget.readOnly) FocusScope.of(context).unfocus();

    return Padding(
      padding:
          widget.padding != null ? widget.padding! : const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: TextField(
              maxLength: 2,
              readOnly: widget.readOnly,
              keyboardType: TextInputType.number,
              onChanged: (value) => widget.onChanged(int.tryParse(value) ?? 0),
              controller: ctrl,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}
