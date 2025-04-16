import 'package:code_path/core/config/app_asset.dart';
import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/presentation/bloc/news/news_bloc.dart';
import 'package:code_path/features/presentation/bloc/news/news_event.dart';
import 'package:code_path/features/presentation/bloc/news/news_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/injection_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/search_field_widget.dart';

class NewsMenu extends StatefulWidget {
  const NewsMenu({super.key});

  @override
  State<NewsMenu> createState() => _NewsMenuState();
}

class _NewsMenuState extends State<NewsMenu> {
  final searchController = TextEditingController();

  String themeNews(String theme) {
    String result = "All";
    if (theme == "android_developer") {
      result = 'Android';
    } else if (theme == 'web_developer') {
      result = 'Web';
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
      create: (context) => s1()..add(const FetchNewsData()),
      child: Builder(
        builder: (newContext) {
          return Column(
            children: [
              const SizedBox(height: 20),
              header(newContext),
              const SizedBox(height: 10),
              SearchFieldWidget(controller: searchController),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    newContext.read<NewsBloc>().add(const FetchNewsData());
                  },
                  child: newsList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }


  newsList() {
    return BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
      if (state.newsList is DataLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.newsList is DataSuccess) {
        if (state.newsList!.data!.isEmpty) {
          return const Center(
            child: Text('Berita tidak tersedia'),
          );
        } else {
          return ListView.builder(
              itemCount: state.newsList!.data!.length,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                News news = state.newsList!.data![index];
                return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.detailNews,
                          arguments: news);
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.secondary),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: AppColor.backgroundScaffold,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 60,
                              decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Center(
                                  child: Text(
                                    themeNews(news.theme!),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              news.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 15,
                                      color: AppColor.backgroundScaffold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  news.createdBy!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColor.primary),
                                ),
                                Text(
                                  AppFormat.date(news.createdAt!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 15,
                                          color: AppColor.backgroundScaffold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
              });
        }
      }

      if(state.newsList is DataFailed){
        return Center(
          child: Text(state.newsList!.error.toString()),
        );
      }

      return const SizedBox();
    });
  }

    header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending News',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              Text(
                'for You',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 26, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          iconNews(context)
        ],
      ),
    );
  }

   iconNews(BuildContext context) {
    return BlocBuilder<NewsBloc,NewsState>(
        builder:(context,state){
          if(state.users is DataSuccess){
            if (state.users!.data!.isAdmin == true) {
              return InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoute.addNews);
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.secondary),
                  child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      )),
                ),
              );
            } else {
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: AppColor.secondary),
                child: Center(
                  child: Image.asset(
                    AppAsset.headerIconNews,
                    width: 35,
                    height: 35,
                    color: AppColor.backgroundScaffold,
                  ),
                ),
              );
            }
          }

          return const SizedBox();
        }
    );
  }

   searchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Stack(children: [
        SizedBox(
          height: 45,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppColor.backgroundSearch,
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Border kustom
                borderSide: BorderSide.none, // Tidak ada garis
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(45),
            child: InkWell(
              onTap: () {
                context.read<NewsBloc>().add(SearchNews(searchController.text));
              },
              borderRadius: BorderRadius.circular(45),
              child: const SizedBox(
                height: 45,
                width: 45,
                child: Center(
                  child: ImageIcon(
                    AssetImage(AppAsset.iconSearch),
                    color: AppColor.backgroundScaffold,
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
