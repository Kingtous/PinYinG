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
    return ListView.builder(itemBuilder: (cxt,index) {
      return Obx(()=>Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state[index].map((e){
              return Padding(
                padding: EdgeInsets.all(1.w),
                child: CharBox(status: e,),
              );
            }).toList(growable: false),
          ),
          Text(controller.words[index])
        ],
      ));
    },itemCount: state.length,);
  }

}
