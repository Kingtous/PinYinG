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
  final node = FocusNode();

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
              padding: EdgeInsets.only(bottom: 16.h),
              child: const Text("Kingtous 2022"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gameController.init(refresh: true).then((value) => {
            Get.defaultDialog(title: "帮助",content: Column(
              children: [
                Row(
                  children: const [
                    Text("灰色表示拼音中无此字母"),
                  ],
                ),
                Row(
                  children: const [
                    Text("黄色表示拼音中有此字母，但是位置不对"),
                  ],
                ),
                Row(
                  children: const [
                    Text("绿色表示拼音中有此字母，且位置正确"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Divider(height: 1,),
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Text("声母表\nb  p  m  f  d  t  n  l  g  k  h  j  q  x  zh  ch  sh  r  z  c  s  y  w",softWrap: true,
                      overflow: TextOverflow.clip,),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Text("韵母表\na  o  e  i  u  ü  ai  ei  ui  ao  ou  iu  ie  üe  er  an  en  in  un  ün  ang  eng  ing  ong"
                      ,softWrap: true,overflow: TextOverflow.clip,),
                    ),
                  ],
                )
              ],
            ))
          });
        },
        child: const Icon(Icons.help),
      ),
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
                  focusNode: node,
                  onSaved: (s) {
                  },
                    onFieldSubmitted: (s){
                    submitAns();
                    }
                  ,
                  validator: (s) {
                    if (s != null && s.length == _gameController.getPinYinString().length) {
                      final _pinyinData = Get.find<PinYinService>().hasPinYin(s);
                      if (_pinyinData != null){
                        Get.snackbar("Hit！", "${_pinyinData.hz}");
                        _tempAnsField = _pinyinData;
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
              decoration: const InputDecoration(
                hintText: "请输入汉字拼音",

              ),
                  maxLength: _gameController.getPinYinString().length,
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    submitAns();
                // _gameController.input(s);
              }, child: const Text("提交/Enter"))
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
      _gameController.input(_tempAnsField!);
      formKey.currentState?.reset();
    } else {
      // ignore
    }
    node.requestFocus();
  }
}
