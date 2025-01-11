import 'package:code_path/config/app_asset.dart';
import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_format.dart';
import 'package:code_path/controller/c_news.dart';
import 'package:code_path/model/news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsMenu extends StatelessWidget {
  NewsMenu({super.key});

  final cNews = Get.put(CNews());
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          header(context),
          const SizedBox(
            height: 20,
          ),
          searchField(),
          const SizedBox(
            height: 30,
          ),
          GetBuilder<CNews>(builder: (data) {
            if (data.listNews == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.listNews.isEmpty) {
              return const Center(
                child: Text('Berita tidak tersedia'),
              );
            } else {
              return ListView.builder(
                  itemCount: data.listNews.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    News news = data.listNews[index];
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                    );
                  });
            }
          })
        ],
      ),
    );
  }

  Row header(BuildContext context) {
    return Row(
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
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.secondary),
          child: Center(
            child: Image.asset(
              AppAsset.headerIconNews,
              width: 35,
              height: 35,
              color: AppColor.backgroundScaffold,
            ),
          ),
        )
      ],
    );
  }

  Stack searchField() {
    return Stack(children: [
      Container(
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
    ]);
  }
}
