//
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();
//
//   static const String baseUrl = 'https://api.themoviedb.org/3';
//   static const String bearerToken = '';
//
//   Future<http.Response> get(String endpoint, {Map<String, String>? queryParams}) async {
//     final Uri uri = Uri.parse('$baseUrl$endpoint').replace(
//       queryParameters: queryParams,
//     );
//
//     return await http.get(
//       uri,
//       headers: {
//         'Authorization': 'Bearer $bearerToken',
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     );
//   }
// }
