import 'package:pinying/generated/json/base/json_convert_content.dart';
import 'package:pinying/bean/pinyin_entity.dart';

PinyinEntity $PinyinEntityFromJson(Map<String, dynamic> json) {
	final PinyinEntity pinyinEntity = PinyinEntity();
	final List<PinyinData>? data = jsonConvert.convertListNotNull<PinyinData>(json['data']);
	if (data != null) {
		pinyinEntity.data = data;
	}
	return pinyinEntity;
}

Map<String, dynamic> $PinyinEntityToJson(PinyinEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['data'] =  entity.data.map((v) => v.toJson()).toList();
	return data;
}

PinyinData $PinyinDataFromJson(Map<String, dynamic> json) {
	final PinyinData pinyinData = PinyinData();
	final String? py = jsonConvert.convert<String>(json['py']);
	if (py != null) {
		pinyinData.py = py;
	}
	final String? hz = jsonConvert.convert<String>(json['hz']);
	if (hz != null) {
		pinyinData.hz = hz;
	}
	return pinyinData;
}

Map<String, dynamic> $PinyinDataToJson(PinyinData entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['py'] = entity.py;
	data['hz'] = entity.hz;
	return data;
}