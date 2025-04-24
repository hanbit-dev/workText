import 'package:flutter/material.dart';
import 'package:worktext/utils/index.dart';

class ColorChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const ColorChip({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: SizedBox(
        width: 84,
        child: Tooltip(
          message: text,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: getTextColorFromBackgroundColor(
                  backgroundColor.value.toString()),
            ),
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      side: BorderSide.none,
    );
  }
}