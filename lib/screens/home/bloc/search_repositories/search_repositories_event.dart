part of 'search_repositories_bloc.dart';

// @immutable
// abstract class SearchRepositoriesEvent {}
//
// class SearchRepositoriesByQuery extends SearchRepositoriesEvent {
//   final String query;
//
//   SearchRepositoriesByQuery({required this.query});
// }
//
// class ClearState extends SearchRepositoriesEvent{}

@freezed
class SearchRepositoriesEvent with _$SearchRepositoriesEvent {
  const factory SearchRepositoriesEvent.searchRepositoriesByQuery(
      {required String query}) = SearchRepositoriesByQuery;

  const factory SearchRepositoriesEvent.updateSearchReposList(
      {required List<ViewData> list}) = UpdateSearchReposList;

  const factory SearchRepositoriesEvent.sortBy(
      {required SearchSort searchSort}) = SortBy;

  const factory SearchRepositoriesEvent.clearState() = ClearState;
}

enum SearchSort { stars, watchers }
