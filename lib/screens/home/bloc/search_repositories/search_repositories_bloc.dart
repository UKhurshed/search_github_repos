import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:search_github_repos/screens/home/data/model/search_repositories_model.dart';
import 'package:search_github_repos/screens/home/data/repository/search_repositories.dart';

part 'search_repositories_event.dart';

part 'search_repositories_state.dart';

class SearchRepositoriesBloc
    extends Bloc<SearchRepositoriesEvent, SearchRepositoriesState> {
  final SearchRepositories searchRepositories;

  SearchRepositoriesBloc({required this.searchRepositories})
      : super(SearchRepositoriesInitial()) {
    on<SearchRepositoriesByQuery>(_mapSearchRepositories);
    on<ClearState>(_mapClearState);
  }

  _mapSearchRepositories(event, emit) async {
    emit(SearchRepositoriesProgress());
    final result = await searchRepositories.searchBySubject(event.query);
    if (result.errorMessage != null) {
      emit(SearchRepositoriesFailure(errorMessage: result.errorMessage!));
    } else {
      emit(SearchRepositoriesSuccess(repositoryItems: result.response.items));
    }
  }

  _mapClearState(event, emit) {
    emit(SearchRepositoriesInitial());
  }
}
