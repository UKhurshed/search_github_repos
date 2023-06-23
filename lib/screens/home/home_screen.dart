import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:search_github_repos/core/database/search_repos_database.dart';
import 'package:search_github_repos/core/extensions/screen_size.dart';
import 'package:search_github_repos/core/route/app_route.dart';
import 'package:search_github_repos/core/route/route_names.dart';
import 'package:search_github_repos/screens/home/bloc/search_repositories/search_repositories_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_github_repos/screens/home/data/repository/search_repositories.dart';
import 'package:search_github_repos/screens/home/widgets/card_avatar.dart';
import 'package:search_github_repos/screens/home/widgets/failure_dialog.dart';
import 'package:search_github_repos/screens/home/widgets/name_and_description.dart';
import 'package:search_github_repos/screens/home/widgets/no_data_view.dart';
import 'package:search_github_repos/screens/home/widgets/search_textfield.dart';
import 'package:search_github_repos/screens/home/widgets/stars_and_watchers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GetIt.I.get<AppLocalizations>().projectName,
              style: const TextStyle(fontSize: 18)),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DriftDbViewer(GetIt.I.get<SearchReposDatabase>())));
                },
                child: const Icon(Icons.note))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.appWidth * 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.appHeight * 12.h),
                const SearchTextField(),
                SizedBox(height: context.appHeight * 15.h),
                Padding(
                    padding: EdgeInsets.only(left: context.appWidth * 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            BlocProvider.of<SearchRepositoriesBloc>(context)
                                .add(
                                    const SortBy(searchSort: SearchSort.stars));
                          },
                          child: Row(
                            children: [
                              Text(GetIt.I.get<AppLocalizations>().sortBy,
                                  style: const TextStyle(color: Colors.black)),
                              SizedBox(width: context.appWidth * 5.w),
                              const Icon(Icons.sort)
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              BlocProvider.of<SearchRepositoriesBloc>(context)
                                  .add(const SortBy(
                                      searchSort: SearchSort.watchers));
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.remove_red_eye),
                                SizedBox(width: context.appWidth * 7.w),
                                Text(GetIt.I.get<AppLocalizations>().sortBy,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ],
                            )),
                      ],
                    )),
                SizedBox(height: context.appHeight * 20.h),
                BlocConsumer<SearchRepositoriesBloc, SearchRepositoriesState>(
                  listener: (context, state) {
                    if (state is SearchRepositoriesFailure) {
                      showDialog(
                          context: context,
                          builder: (BuildContext dlgContext) {
                            return FailureDialog(
                                errorMessage: state.errorMessage);
                          });
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchRepositoriesInitial) {
                      return const NoDataView();
                    } else if (state is SearchRepositoriesProgress) {
                      return const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    } else if (state is SearchRepositoriesSuccess) {
                      return ListOfRepositories(listItem: state.listItem);
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class ListOfRepositories extends StatefulWidget {
  final List<ViewData> listItem;

  const ListOfRepositories({super.key, required this.listItem});

  @override
  State<ListOfRepositories> createState() => _ListOfRepositoriesState();
}

class _ListOfRepositoriesState extends State<ListOfRepositories> {
  List<ViewData> get itemList => widget.listItem;

  List<ViewData> currentList = [];

  @override
  void initState() {
    currentList = itemList;
    super.initState();
  }

  void _updateItem(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }
    final localItem = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, localItem);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView(
          shrinkWrap: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              _updateItem(oldIndex, newIndex);
            });
          },
          children: List.generate(
            currentList.length,
            (index) {
              final item = currentList[index];
              if (currentList.isEmpty) {
                return const NoDataView();
              } else {
                return InkWell(
                  key: ValueKey('search: ${item.id}'),
                  onTap: () {
                    AppRouter.router.pushNamed(RouteNames.repositoryHtmlUrl,
                        queryParameters: {'htmlUrl': item.htmlURL ?? ""});
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: context.appHeight * 4.h),
                    child: Container(
                      height: context.appHeight * 80.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appWidth * 10.w),
                        child: Row(
                          children: [
                            item.avatarURL == null
                                ? const EmptyAvatar()
                                : AvatarWithUrl(url: item.avatarURL ?? ""),
                            SizedBox(width: context.appWidth * 10.w),
                            NameAndDescription(item: item),
                            SizedBox(width: context.appWidth * 15.w),
                            StarsAndWatchers(item: item)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          )),
    );
  }
}
