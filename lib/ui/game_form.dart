import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinying/bean/pinyin_entity.dart';
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
  PinyinData? _tempAnsField;
  static final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    _gameController = Get.find<GameController>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          const Text("点击右下角查看游戏玩法！"),
          Obx(()=> Text("你还有${_gameController.remainTimes.value}次机会哦").paddingAll(8.w)),
          buildForm(),
          buildKeybord(context),
        ],
      ),
    );
  }


  Widget buildForm() {
    return const Board();
  }

  Widget buildKeybord(BuildContext context){
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
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
                  focusNode: node,
                  autovalidateMode: AutovalidateMode.disabled,
                  onSaved: (s) {
                    _tempAnsField = Get.find<PinYinService>().hasPinYin(s!);
                  },
                    onFieldSubmitted: (s){
                    // Future.delayed(Duration.zero,(){
                    //   submitAns(context);
                    // });
                    }
                  ,
                  validator: (s) {
                    if (s != null && s.length == _gameController.getPinYinString().length) {
                      final _pinyinData = Get.find<PinYinService>().hasPinYin(s);
                      if (_pinyinData != null){
                        // Get.snackbar("Hit！", "${_pinyinData.hz}");
                        return null;
                      } else {
                        // if (kDebugMode){
                        //   return null;
                        // } else {
                        Future.delayed(Duration.zero,(){
                          FocusScope.of(context).requestFocus(node);
                        });
                        return "查无此拼音哦~";

                        // }
                      }
                    } else {
                      Future.delayed(Duration.zero,(){
                        FocusScope.of(context).requestFocus(node);
                      });
                      return "谜底为${_gameController.getPinYinString().length}个拼音字母哦~";
                    }
                  },
              decoration: const InputDecoration(
                hintText: "请输入你想到的任意词语拼音",

              ),
                  maxLength: _gameController.getPinYinString().length,
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    submitAns(context);
                // _gameController.input(s);
              }, child: const Text("提交"))
            ],
          ),
        ),
      ),
    );
  }

  void submitAns(BuildContext context){
    if (true == formKey.currentState!.validate()){
      formKey.currentState!.save();
      // ok
      _gameController.input(_tempAnsField!);
      formKey.currentState!.reset();
      Future.delayed(Duration.zero,(){
        FocusScope.of(context).requestFocus(node);
      });
    } else {
      // ignore
    }
    // formKey.currentState!.activate();
    // Focus.of(context).requestFocus(node);
    // node.requestFocus();
  }
}
