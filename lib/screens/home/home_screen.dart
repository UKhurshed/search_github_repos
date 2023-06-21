import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:search_github_repos/core/extensions/screen_size.dart';
import 'package:search_github_repos/core/route/app_route.dart';
import 'package:search_github_repos/core/route/route_names.dart';
import 'package:search_github_repos/screens/home/bloc/search_repositories/search_repositories_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_github_repos/screens/home/widgets/failure_dialog.dart';
import 'package:search_github_repos/screens/home/widgets/no_data_view.dart';
import 'package:search_github_repos/screens/home/widgets/search_textfield.dart';

import 'data/model/search_repositories_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.appWidth * 8.w),
        child: Column(
          children: [
            SizedBox(height: context.appHeight * 12.h),
            const SearchTextField(),
            SizedBox(height: context.appHeight * 20.h),
            BlocConsumer<SearchRepositoriesBloc, SearchRepositoriesState>(
              listener: (context, state) {
                if (state is SearchRepositoriesFailure) {
                  showDialog(
                      context: context,
                      builder: (BuildContext dlgContext) {
                        return FailureDialog(errorMessage: state.errorMessage);
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
                  return ListOfRepositories(items: state.repositoryItems);
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

class ListOfRepositories extends StatelessWidget {
  final List<Item> items;

  const ListOfRepositories({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = items[index];
            log('item avatar: ${item.owner?.avatarUrl}');
            if (items.isEmpty) {
              return const NoDataView();
            } else {
              return InkWell(
                onTap: () {
                  AppRouter.router.pushNamed(RouteNames.repositoryHtmlUrl,
                      queryParameters: {'htmlUrl': item.owner?.htmlUrl ?? ""});
                },
                child: Container(
                  height: context.appHeight * 80.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.appWidth * 10.w),
                    child: Row(
                      children: [
                        item.owner?.avatarUrl == null
                            ? Container(
                                width: context.appWidth * 42.w,
                                height: context.appHeight * 42.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xFF9FD6FD),
                                        width: 1),
                                    color: const Color(0xFFECF7FF)),
                                child: const Center(
                                    child: Icon(Icons.person_rounded)),
                              )
                            : Container(
                                width: context.appWidth * 50.w,
                                height: context.appHeight * 50.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color(0xFF9FD6FD),
                                      width: 1.0),
                                  color: const Color(0xFFECF7FF),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          item.owner?.avatarUrl ?? ""),
                                      fit: BoxFit.contain),
                                )),
                        SizedBox(width: context.appWidth * 10.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: context.appHeight * 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.fullName ?? "",
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(item.description ?? "No description",
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: context.appWidth * 15.w),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: context.appHeight * 8.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('${item.stargazersCount ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: context.appWidth * 2.w),
                                  const Icon(Icons.star,
                                      color: Colors.black, size: 16)
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${item.watchersCount ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: context.appWidth * 2.w),
                                  const Icon(Icons.remove_red_eye,
                                      color: Colors.black, size: 16)
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: context.appHeight * 8.h);
          },
          itemCount: items.length),
    );
  }
}
