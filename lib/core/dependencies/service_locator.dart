import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:search_github_repos/screens/home/bloc/search_repositories/search_repositories_bloc.dart';
import 'package:search_github_repos/screens/home/data/repository/search_repositories.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  void registerDependency(BuildContext context) {
    getIt.registerSingleton<AppLocalizations>(AppLocalizations.of(context)!);
    getIt.registerFactory(
        () => SearchRepositoriesBloc(searchRepositories: getIt()));
    getIt.registerLazySingleton<SearchRepositories>(
        () => SearchRepositoriesImpl());
  }
}
