import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  static final ads = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-4754225129255140/6858501246",
      listener: const BannerAdListener(),
      request: const AdRequest());

  @override
  void initState() {
    super.initState();
    _gameController = Get.find<GameController>();
    ads.load().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
            child: AdWidget(ad: ads),
          ),
          // Obx(()=> Text(_gameController.getHanZiString())),
          // Obx(()=> Text(_gameController.getPinYinString())),
          Obx(
            () => Offstage(
              offstage: !_gameController.canShowAns(),
              child: Text(_gameController.getHanZiString()),
            ),
          ),
          Obx(
            () => Offstage(
              offstage: !_gameController.canShowAns(),
              child: Text(_gameController.getPinYinString()),
            ),
          ),
          const Text("点击右下角查看游戏玩法！每日一道题！"),
          Obx(() => BrnEnhanceNumberCard(
                  backgroundColor: Colors.transparent,
                  itemChildren: [
                    BrnNumberInfoItemModel(
                        preDesc: "你还有",
                        number: "${_gameController.remainTimes.value}",
                        lastDesc: "次机会哦")
                  ])).paddingAll(8.w),
          buildForm(),
          buildKeybord(context),
          const Text("Created By Kingtous. Inspired By Wordle.")
              .paddingSymmetric(vertical: 8.h)
        ],
      ),
    );
  }

  Widget buildForm() {
    return const Board();
  }

  Widget buildKeybord(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: formKey,
      child: Obx(
        () => Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  focusNode: node,
                  autovalidateMode: AutovalidateMode.disabled,
                  onSaved: (s) {
                    _tempAnsField = Get.find<PinYinService>().hasPinYin(s!);
                  },
                  onFieldSubmitted: (s) {
                    // Future.delayed(Duration.zero,(){
                    //   submitAns(context);
                    // });
                  },
                  validator: (s) {
                    if (s != null &&
                        s.length == _gameController.getPinYinString().length) {
                      final _pinyinData =
                          Get.find<PinYinService>().hasPinYin(s);
                      if (_pinyinData != null) {
                        // Get.snackbar("Hit！", "${_pinyinData.hz}");
                        return null;
                      } else {
                        // if (kDebugMode){
                        //   return null;
                        // } else {
                        Future.delayed(Duration.zero, () {
                          FocusScope.of(context).requestFocus(node);
                        });
                        return "查无此拼音哦~";

                        // }
                      }
                    } else {
                      Future.delayed(Duration.zero, () {
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
              BrnNormalButton(
                onTap: () {
                  submitAns(context);
                  // _gameController.input(s);
                },
                text: '提交',
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitAns(BuildContext context) {
    if (true == formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // ok
      _gameController.input(_tempAnsField!);
      formKey.currentState!.reset();
      Future.delayed(Duration.zero, () {
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
