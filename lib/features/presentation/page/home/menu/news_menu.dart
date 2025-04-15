import 'package:code_path/core/config/app_asset.dart';
import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/features/presentation/controller/c_news.dart';
import 'package:code_path/features/presentation/controller/c_user.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsMenu extends StatefulWidget {
  const NewsMenu({super.key});

  @override
  State<NewsMenu> createState() => _NewsMenuState();
}

class _NewsMenuState extends State<NewsMenu> {
  final cNews = Get.put(CNews());
  final cUser = Get.put(CUser());
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
    cNews.getListNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        header(context),
        const SizedBox(
          height: 10,
        ),
        searchField(),
        Expanded(
            child: RefreshIndicator(
                child: newsList(), onRefresh: () => cNews.getListNews()))
      ],
    );
  }

  GetBuilder<CNews> newsList() {
    return GetBuilder<CNews>(builder: (data) {
      if (data.listNews.isEmpty) {
        return const Center(
          child: Text('Berita tidak tersedia'),
        );
      } else {
        return ListView.builder(
            itemCount: data.listNews.length,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              News news = data.listNews[index];
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
    });
  }

  Padding header(BuildContext context) {
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

  Widget iconNews(BuildContext context) {
    if (cUser.data.isAdmin == true) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.addNews);
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

  Padding searchField() {
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
                cNews.searchNews(searchController.text);
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
