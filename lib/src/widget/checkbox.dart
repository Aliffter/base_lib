import 'package:flutter/cupertino.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({
    super.key,
    this.value = false,
    this.onChanged,
    this.margin,
    this.padding,
    this.size = 20,
  });
  final bool value;
  final void Function(bool ischecked)? onChanged;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double size;

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;
  @override
  void initState() {
    isChecked = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      isChecked = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChanged == null
          ? null
          : () {
              setState(() {
                isChecked = !isChecked;
                widget.onChanged?.call(isChecked);
              });
            },
      child: _buildCheckbox(),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Image.asset(
        isChecked
            ? 'lib/assets/common/checkbox_selected.png'
            : 'lib/assets/common/checkbox_default.png',
        package: 'kiwin_lib',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      ),
    );
  }
}
