import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinying/controller/game_controller.dart';
import 'package:pinying/service/pinyin_service.dart';
import 'package:pinying/ui/game_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() =>
    PinYinService().init()
  );
  await Get.putAsync(() => GameController().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PinYinG - 猜拼音',
      // theme: ThemeData.dark(),
      home: const MyHomePage(title: 'PinYinG - 猜拼音'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      appBar: BrnAppBar(
        title: widget.title,
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: const GameForm(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(title: "帮助", textCancel: "我知道了",

              content: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: Text("你需要猜中一个2字词语的所有拼音字母，一共有5次机会。假设一个词语为\"现在\"，那么你需要在5次机会内，猜出"
                          "xianzai这7个拼音字母。\n你需要想一个存在的2字词语，这个词语的拼音总长度刚好等于一行的格子数量，即谜底的拼音总长。\n每次输入会占用一行（即一次机会），提交后会获得猜测结果，通过结果给出的提示来逐步推断出谜底拼音。")),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Divider(height: 1,),
                  ),
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
              ));
        },
        child: const Icon(Icons.help),
      ),
    );
  }
}
