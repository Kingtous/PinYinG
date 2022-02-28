import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinying/bean/pinyin_entity.dart';
import 'package:pinying/controller/game_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinying/ui/component/charbox.dart';

class Board extends GetWidget<GameController> {

  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = controller.states;
    final widgets = List<Widget>.empty(growable: true);
    for (var i=0;i<state.length;i++){
      var s = state[i];
      var duration = Duration(milliseconds: 200 * i);
      widgets.add(Obx(
        ()=> Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: s.map((e){
                return Padding(
                  padding: EdgeInsets.all(1.w),
                  child: FlipInY(
                    duration: const Duration(milliseconds: 1000),
                      delay: duration,
                      child: CharBox(status: e,)),
                );
              }).toList(growable: false),
            ),
            Text(controller.words[i])
          ],
        ),
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

}
