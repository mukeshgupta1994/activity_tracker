import 'dart:convert';
import 'dart:io';
import 'package:activity_tracker/data/local/hive_helper.dart';
import 'package:activity_tracker/data/remote/app_exception.dart';
import 'package:activity_tracker/data/remote/network/base_api_service.dart';
import 'package:activity_tracker/repository/db_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class NetworkApiService extends BaseApiService {
  final DbRepository dbRepository;
  final http.Client httpClient;

  NetworkApiService(
    this.dbRepository,
    this.httpClient,
  );
  @override
  Future get(String url) async {
    dynamic responseJson;
    try {
      final response = await httpClient.get(
        Uri.parse(baseUrl + url),
        headers: headers,
      );
      responseJson = returnResponse(
        response,
        apiName: url,
        request: '',
      );
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on http.ClientException {
      throw FetchDataException('Something went wrong..\nPlease try again!!');
    }
    debugPrint("Response: $responseJson");
    return responseJson;
  }

  @override
  Future post(String url, {Map<String, dynamic>? data = const {}}) async {
    debugPrint("🐣 Api Request: $baseUrl$url");
    debugPrint("🐸 Request: $data");
    dynamic responseJson;
    try {
      final response = await httpClient.post(
        Uri.parse(baseUrl + url),
        body: jsonEncode(data),
        headers: headers,
      );
      responseJson = returnResponse(
        response,
        apiName: url,
        request: data.toString(),
      );
      debugPrint("🐥 Api Response: $baseUrl$url");
      debugPrint("🐝 Response: $responseJson");
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on http.ClientException {
      throw FetchDataException('Something went wrong..\nPlease try again!!');
    }
  }

  @override
  Future<void> errorPost({
    required String? errorCode,
    required String? errorName,
    required String? remarks,
    required String? apiName,
    required String? request,
    required int? userId,
  }) async {
    const url = 'JconnectPlusAppErrorLog';
    final Map<String, dynamic> data = {
      "ErrorCode": errorCode,
      "ErrorName": errorName,
      "Remarks": remarks,
      "ApiName": apiName,
      "Request": request,
      "AppName": "JconnectPlusApp",
      "UserID": userId,
      "Latitude": 0.0,
      "Longitude": 0.0,
    };

    debugPrint("🐣 Api Request: $baseUrl$url");
    debugPrint("🐸 Request: $data");
    dynamic responseJson;
    try {
      final response = await httpClient.post(
        Uri.parse(baseUrl + url),
        body: jsonEncode(data),
        headers: headers,
      );
      responseJson = response.body;
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint("🐥 Api Response: $baseUrl$url");
    debugPrint("🐝 Response: $responseJson");
  }

  dynamic returnResponse(
    http.Response response, {
    required String apiName,
    required String request,
  }) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        errorPost(
          errorCode: response.statusCode.toString(),
          apiName: apiName,
          errorName: response.body,
          remarks: '',
          request: request,
          userId: int.tryParse(HiveHelper.userId) ?? 0,
        );
        throw FetchDataException(
            'Something went wrong...\nstatus : ${response.statusCode}');
    }
  }
}
