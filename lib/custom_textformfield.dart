import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final void Function(String) onChanged;
  final bool isInputEmpty;
  final void Function()? onClear;
  final String initialValue;
  final int minLines;
  final int maxLines;
  final bool isBoolean;
  final bool isReadOnly;
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.onChanged,
    required this.isInputEmpty,
    this.onClear,
    required this.initialValue,
    this.minLines = 1,
    this.maxLines = 1,
    this.isBoolean = false,
    this.isReadOnly = false,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CustomTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearTextField() {
    if (widget.onClear != null) {
      widget.onClear!();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: Color(0xFFDDDDDD), // Label text color
            fontSize: 16, // Adjust the font size as needed
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8), // Spacing between label text and TextFormField
        TextFormField(
          obscureText: widget.obscureText,
          readOnly: widget.isReadOnly, // Add this line
          onTap: widget.isBoolean
              ? () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return 
          Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 250,
        color: const Color.fromARGB(255, 31, 33, 38),
                      child:
                      Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              'Select ${widget.labelText}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
                            const SizedBox(height: 24),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child:
                            InkWell(
                              splashColor: Colors.transparent, // Removes the splash color
                              child: Text(
                                'Yes (there is a presence of cysts)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                widget.onChanged('true');
                                Navigator.of(context).pop();
                              },
                            ),
                            ),
                            const SizedBox(height: 24),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child:
                            InkWell(
                              splashColor: Colors.transparent, // Removes the splash color
                              child: Text(
                                'No (there is no presence of cysts)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                widget.onChanged('false');
                                Navigator.of(context).pop();
                              },
                            ),
                            ),
                          ],
                        ),
                        ),
                      );
                    },
                  );
                }
              : null,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          cursorColor: Colors.black,
          controller: _controller,
          style: TextStyle(
            color: Colors.black, // Text color inside the field
          ),
          decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never, // Ensures the label doesn't float
            filled: true, // Enables the fillColor property
            fillColor: Color(0xFFC3C3C3), // Background color for the TextFormField
            labelStyle: TextStyle(color: Colors.black.withOpacity(0),), // Makes label text transparent
            border: OutlineInputBorder( // Outline border when TextFormField is enabled
              borderSide: BorderSide.none, // No border side
              borderRadius: BorderRadius.circular(5.0), // Rounded corners like the CustomDropdownButton
            ),
            enabledBorder: OutlineInputBorder( // Outline border when TextFormField is enabled and not focused
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder( // Outline border when TextFormField is focused
              borderSide: BorderSide(
                color: Colors.black, // Color for the focused border
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            suffixIcon: widget.isReadOnly ? null : widget.isInputEmpty ? null : IconButton(
              onPressed: _clearTextField,
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged(value);
            }
          },
        ),
      ],
    );
  }
}
