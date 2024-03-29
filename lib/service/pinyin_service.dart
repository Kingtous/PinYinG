import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinying/bean/pinyin_entity.dart';

class PinYinService extends GetxService {
  late PinyinEntity _pinyinEntity;
  PinyinData? _data;

  Future<PinYinService> init() async {
    final string = await rootBundle.loadString("assets/data.json");
    _pinyinEntity = PinyinEntity.fromJson(json.decode(string));
    return this;
  }

  PinyinData getPinYin({bool refresh = false}) {
    if (_data == null || refresh) {
      final date = (DateTime.now().toLocal().millisecondsSinceEpoch -
              DateTime(2000).toLocal().millisecondsSinceEpoch) /
          (1000 * 3600 * 24);
      final index = Random(refresh ? null : date.toInt())
          .nextInt(_pinyinEntity.data.length);
      _data = _pinyinEntity.data[index];
    }
    return _data!;
  }

  PinyinData? hasPinYin(String pinyin) {
    final it = _pinyinEntity.data.where((element) => element.py == pinyin);
    return it.isNotEmpty ? it.first : null;
  }

  Iterable<PinyinData> getPinYinSearch(String pinyin, int length) {
    final it = _pinyinEntity.data.where((element) =>
        element.py.startsWith(pinyin.toLowerCase()) &&
        element.py.length == length);
    return it;
  }
}
