
abstract class BaseApiService {
  Future<dynamic> getApi(String url, {Map<String, String>? headers});
  Future<dynamic> postApi(String url, dynamic data, {Map<String, String>? headers});
  Future<dynamic> putApi(String url, dynamic data, {Map<String, String>? headers});
  Future<dynamic> deleteApi(String url, {Map<String, String>? headers});
  Future<dynamic> multipartApi(String url, Map<String, String> data, String filePath, String fileField);
}
