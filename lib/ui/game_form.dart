import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinying/controller/game_controller.dart';
import 'package:pinying/service/pinyin_service.dart';
import 'package:pinying/ui/component/board.dart';

class GameForm extends StatefulWidget {
  const GameForm({Key? key}) : super(key: key);

  @override
  _GameFormState createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {

  late GameController _gameController;
  static final formKey = GlobalKey<FormState>();
  String _tempAnsField = "";

  @override
  void initState() {
    super.initState();
    _gameController = Get.find<GameController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Obx(()=> Text(_gameController.getHanZiString())),
            // Obx(()=> Text(_gameController.getPinYinString())),
            Obx(
            ()=> Offstage(
                offstage: !_gameController.canShowAns(),
                child: Text(_gameController.getHanZiString()),
              ),
            ),
            Obx(
            ()=> Offstage(
                offstage: !_gameController.canShowAns(),
                child: Text(_gameController.getPinYinString()),
              ),
            ),
            Obx(()=> Text("你还有${_gameController.remainTimes.value}次机会哦").paddingAll(8.w)),
            Expanded(child: buildForm()),
            buildKeybord(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Kingtous 2022"),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _gameController.init(refresh: true).then((value) => {
      //       Get.snackbar("重新开始！", "请继续你的挑战！")
      //     });
      //   },
      //   child: const Icon(Icons.loop),
      // ),
    );
  }


  Widget buildForm() {
    return const Board();
  }

  Widget buildKeybord(){
    return Form(
      key: formKey,
      child: Obx(
        ()=> Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                child: TextFormField(
                  autofocus: true,
                  onSaved: (s) {
                    _tempAnsField = s ?? "";
                  },
                    onFieldSubmitted: (s){
                    submitAns();
                    }
                  ,
                  validator: (s) {
                    if (s != null && s.length == _gameController.getPinYinString().length) {
                      if (Get.find<PinYinService>().hasPinYin(s)){
                        return null;
                      } else {
                        // if (kDebugMode){
                        //   return null;
                        // } else {
                        return "查无此拼音哦~";

                        // }


                      }
                    } else {
                      return "谜底为${_gameController.getPinYinString().length}个拼音字母哦~";
                    }
                  },
              decoration: InputDecoration(
                hintText: "请输入汉字拼音",

              ),
                  maxLength: _gameController.getPinYinString().length,
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    submitAns();
                // _gameController.input(s);
              }, child: Text("提交"))
            ],
          ),
        ),
      ),
    );
  }

  void submitAns(){
    if (true == formKey.currentState?.validate()){
      formKey.currentState?.save();
      // ok
      _gameController.input(_tempAnsField);
      formKey.currentState?.reset();
    } else {
      // ignore
    }
  }
}
