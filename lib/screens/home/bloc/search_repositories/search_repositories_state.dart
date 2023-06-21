part of 'search_repositories_bloc.dart';

@immutable
abstract class SearchRepositoriesState {}

class SearchRepositoriesInitial extends SearchRepositoriesState {}

class SearchRepositoriesProgress extends SearchRepositoriesState {}

class SearchRepositoriesSuccess extends SearchRepositoriesState {
  final SearchRepositoriesModel searchRepositoriesModel;

  SearchRepositoriesSuccess({required this.searchRepositoriesModel});
}

class SearchRepositoriesFailure extends SearchRepositoriesState {
  final String errorMessage;

  SearchRepositoriesFailure({required this.errorMessage});
}
