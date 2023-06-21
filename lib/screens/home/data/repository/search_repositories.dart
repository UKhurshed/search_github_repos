import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:search_github_repos/core/network/dio_exceptions.dart';
import 'package:search_github_repos/core/network/dio_helper.dart';
import 'package:search_github_repos/screens/home/data/model/search_repositories_model.dart';

abstract class SearchRepositories {
  Future<ResponseFromRequest> searchBySubject(String query);
}

class SearchRepositoriesImpl implements SearchRepositories {
  @override
  Future<ResponseFromRequest> searchBySubject(String query) async {
    try {
      final searchResponse =
          await API().dio.get('search/repositories?q=$query');
      log('searchResponse: ${searchResponse.statusCode} & ${searchResponse.data}');
      return ResponseFromRequest(
          response: SearchRepositoriesModel.fromJson(searchResponse.data));
    } on DioException catch (error) {
      final errorMessage = DioExceptions.fromDioError(error);
      log('SearchRepositoriesImpl DioError: $errorMessage');
      return ResponseFromRequest(errorMessage: errorMessage);
    } catch (error) {
      log('SearchRepositoriesImpl error: ${error.toString()}');
      return ResponseFromRequest(errorMessage: error.toString());
    }
  }
}

class ResponseFromRequest {
  final dynamic response;
  final String? errorMessage;

  ResponseFromRequest({this.response, this.errorMessage});
}
