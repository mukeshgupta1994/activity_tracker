abstract class BaseApiService {
  //UAT
  final baseUrl = "https://uat.jfsl.in/ACTIVATIONTRACKERAPI/api/API/";

  // final String baseUrl = "https://webapps.jyothy.com/Jconnectplus/api/API/";

  //PRODUCTION
  // final baseUrl = "https://api.jyothy.com/api/API/";

  // //TEST API
  // final baseUrl = "https://live.jfsl.in/TestJconnectPlus/api/API/";

  final headers = {
    'Content-Type': 'application/json',
    'X-Cleartax-Auth-Token': '5e750eb7-ba46-467c-a8ba-42401dab5c20',
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
  };

  Future<dynamic> get(String url);

  Future<dynamic> post(String url, {Map<String, dynamic>? data = const {}});

  Future<void> errorPost({
    required String? errorCode,
    required String? errorName,
    required String? remarks,
    required String? apiName,
    required String? request,
    required int? userId,
  });
}
