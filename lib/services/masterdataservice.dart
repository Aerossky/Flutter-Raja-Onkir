part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          'Content-type': 'application/json; chartset=UTF-8',
          'key': Const.apiKey
        });

    var job = jsonDecode(response.body);
    print(job.toString());
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }

    return result;
  }
}
