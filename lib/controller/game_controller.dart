import 'package:get/get.dart';
import 'package:pinying/bean/pinyin_entity.dart';
import 'package:pinying/service/pinyin_service.dart';
import 'package:pinying/ui/component/charbox.dart';


class GameController extends GetxController{

  Rx<PinyinData?> _data = Rx(null);
  late RxList<RxList<CharBoxStatus>> states;
  late RxList<String> words;

  var maxTriedTimes = 5;
  var remainTimes = 5.obs;
  var isWon = false.obs;

  Future<GameController> init({bool refresh = false}) async {
    _data.value = Get.find<PinYinService>().getPinYin(refresh: refresh);
    // maxTriedTimes = _data.value!.py.length;
    final pinyinLength = _data.value!.py.length;
    states = List.generate(maxTriedTimes, (_) => List.generate(pinyinLength, (_)=>
      CharBoxStatus(Status.none,"")).obs).obs;
    words = List.generate(maxTriedTimes, (index) => "").obs;
    isWon = false.obs;
    remainTimes = maxTriedTimes.obs;
    return this;
  }

  bool canShowAns() {
    return isWon.value || remainTimes.value == 0;
  }

  String getPinYinString(){
    return _data.value!.py;
  }

  String getHanZiString(){
    return _data.value!.hz;
  }

  void reset(){
    remainTimes.value = 0;
  }

  bool input(PinyinData data){
    String s = data.py;
    if (isWon.value){
      Get.defaultDialog(title: "你已经胜利了！",middleText: "胜利虽好，可不要贪杯哦~");
      return true;
    }
    if (remainTimes.value > 0) {
      final units = s.codeUnits;
      final rightAnswerUnits = getPinYinString().codeUnits;
      for (var i = 0; i< units.length; i++){
        states[maxTriedTimes - remainTimes.value][i] = CharBoxStatus(rightAnswerUnits[i] == units[i] ?
        Status.right : rightAnswerUnits.contains(units[i]) ? Status.hit : Status.diff, String.fromCharCode(units[i]));
        words[maxTriedTimes - remainTimes.value] = data.hz;
      }
      remainTimes.value = remainTimes.value - 1;
      if (s == getPinYinString()){
        isWon.value = true;
        Get.defaultDialog(title: "挑战成功！",middleText: "恭喜你！花费${maxTriedTimes - remainTimes.value}次完成了猜测！");
        return true;
      }
      if (remainTimes.value == 0){
        Get.defaultDialog(title: "挑战失败",middleText: "已经没有机会咯~");
      }
      return true;
    } else {
      Get.defaultDialog(title: "提示",middleText: "已经没有机会咯~");
      return false;
    }
  }

}