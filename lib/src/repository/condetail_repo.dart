//공연 상세 정보(ConcertDetail) 페이지
import 'package:artroad/src/model/condetail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:xml2json/xml2json.dart';

class ConcertDetailRepository {
  Future<List<ConcertDetail>?> loadConcertDetails(String concertID) async{
    await dotenv.load();
    String apiKey = dotenv.env['API_KEY']!;
    String baseUrl = 
      "http://www.kopis.or.kr/openApi/restful/pblprfr/$concertID?service=$apiKey";
    
    //null값일때 none으로 바꾸기
    String replaceNullWithFieldKey(String key, dynamic value) {
      return value ?? key;
    }

    final response = await http.get(Uri.parse(baseUrl));

    if(response.statusCode == 200){
      try{
        final body = convert.utf8.decode(response.bodyBytes);
        final xml = Xml2Json()..parse(body);
        final json = xml.toParker();

        Map<String, dynamic> jsonResult = convert.jsonDecode(json);
        final jsonConcertDetail = jsonResult['dbs']['db'];
        // jsonConcertDetail.removeWhere((key, value) => value == null);
        if (jsonConcertDetail != null) {
          return [ConcertDetail.fromJson(jsonConcertDetail)];
        } 
        }
      finally{
      }
    } return null;
  }
}