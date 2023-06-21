part of 'search_repositories_bloc.dart';

@immutable
abstract class SearchRepositoriesEvent {}

class SearchRepositoriesByQuery extends SearchRepositoriesEvent {
  final String query;

  SearchRepositoriesByQuery({required this.query});
}

class ClearState extends SearchRepositoriesEvent{}
