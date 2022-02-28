import 'dart:convert';
import 'package:pinying/generated/json/base/json_field.dart';
import 'package:pinying/generated/json/pinyin_entity.g.dart';

@JsonSerializable()
class PinyinEntity {

	late List<PinyinData> data;
  
  PinyinEntity();

  factory PinyinEntity.fromJson(Map<String, dynamic> json) => $PinyinEntityFromJson(json);

  Map<String, dynamic> toJson() => $PinyinEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PinyinData {

	late String py;
	late String hz;
  
  PinyinData();

  factory PinyinData.fromJson(Map<String, dynamic> json) => $PinyinDataFromJson(json);

  Map<String, dynamic> toJson() => $PinyinDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}