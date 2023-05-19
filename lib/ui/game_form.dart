import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  String? _tempText;
  static final FocusNode node = FocusNode();
  static final ads = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-4754225129255140/6858501246",
      listener: const BannerAdListener(),
      request: const AdRequest());
  bool isAdLoaded = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gameController = Get.find<GameController>();
    ads.load().then((value) {
      setState(() {
        isAdLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (isAdLoaded)
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
          const SizedBox(
            height: 4.0,
          ),
          buildKeybord(context),
          Obx(() => BrnEnhanceNumberCard(
                  backgroundColor: Colors.transparent,
                  itemChildren: [
                    BrnNumberInfoItemModel(
                        preDesc: "你还有",
                        number: "${_gameController.remainTimes.value}",
                        lastDesc: "次机会哦")
                  ])).paddingAll(8.w),
          buildForm(),

          const Text("Created By Kingtous. Inspired By Wordle.")
              .paddingSymmetric(vertical: 8.h),
        ],
      ),
    );
  }

  Widget buildForm() {
    return const Board();
  }

  Widget buildKeybord(BuildContext context) {
    return Obx(
      () => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TypeAheadField<PinyinData>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _textEditingController,
                  autofocus: false,
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontStyle: FontStyle.italic),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "请输入你想到的任意词语拼音",
                  ),
                  scrollPadding: EdgeInsets.zero,
                  onChanged: (text) {
                    setState(() {
                      _tempText = text;
                    });
                  },
                  maxLength: _gameController.getPinYinString().length,
                ),
                suggestionsCallback: (Pattern pattern) async {
                  if (pattern.toString().isEmpty) {
                    return [];
                  }
                  return Get.find<PinYinService>().getPinYinSearch(
                      pattern.toString(),
                      _gameController.getPinYinString().length);
                },
                // validator: (s) {
                //   if (s != null &&
                //       s.length == _gameController.getPinYinString().length) {
                //     final _pinyinData =
                //         Get.find<PinYinService>().hasPinYin(s);
                //     if (_pinyinData != null) {
                //       // Get.snackbar("Hit！", "${_pinyinData.hz}");
                //       return null;
                //     } else {
                //       // if (kDebugMode){
                //       //   return null;
                //       // } else {
                //       Future.delayed(Duration.zero, () {
                //         FocusScope.of(context).requestFocus(node);
                //       });
                //       return "查无此拼音哦~";
                //     }
                //   } else {
                //     Future.delayed(Duration.zero, () {
                //       FocusScope.of(context).requestFocus(node);
                //     });
                //     return "谜底为${_gameController.getPinYinString().length}个拼音字母哦~";
                //   }
                // },
                itemBuilder: (BuildContext context, itemData) {
                  return ListTile(
                    title: Text(itemData.py),
                    subtitle: Text(itemData.hz),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _tempAnsField = suggestion;
                  _tempText = suggestion.py;
                  _textEditingController.text = suggestion.py;
                },
              ),
            ),
            SizedBox(
              width: 8.w,
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
    );
  }

  void submitAns(BuildContext context) {
    _gameController.input(_tempAnsField!);
  }
}
