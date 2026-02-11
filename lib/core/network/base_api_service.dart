
abstract class BaseApiService {

  Future<dynamic> getApi(String url, {Map<String, String>? headers});
  Future<dynamic> postApi(String url, dynamic data, {Map<String, String>? headers});

}
