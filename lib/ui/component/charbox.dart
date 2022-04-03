import 'dart:ui';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CharBoxStatus {
  Status status;
  String field;

  CharBoxStatus(this.status, this.field);
}

enum Status { none, diff, hit, right }

extension ColorExtension on Status {
  Color getColor() {
    switch (this) {
      case Status.none:
        return Colors.transparent;
      case Status.diff:
        return Colors.grey;
      case Status.hit:
        return Colors.yellow;
      case Status.right:
        return Colors.green;
    }
  }
}

class CharBox extends StatelessWidget {
  final CharBoxStatus status;

  const CharBox({Key? key, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BrnShadowCard(
      child: Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: status.status.getColor(),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black87.withOpacity(0.5))
        ),
        // padding: EdgeInsets.all(16.w),
        child: Text(
          status.field,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        )
      ),
    );
  }
}
