import 'package:code_path/config/app_asset.dart';
import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_format.dart';
import 'package:code_path/controller/c_news.dart';
import 'package:code_path/controller/c_user.dart';
import 'package:code_path/model/news.dart';
import 'package:code_path/widget/base_button.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class DetailNewsPage extends StatefulWidget {
  const DetailNewsPage({super.key});

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  final cNews = Get.put(CNews());
  final cUser = Get.put(CUser());
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    News newsArg = ModalRoute.of(context)!.settings.arguments as News;

    final List<Map> listNav = [
      {'icon': AppAsset.iconHome, 'label': 'Show Comment'},
    ];

    getNewsImage() {
      if (newsArg.theme == "android_developer") {
        return AppAsset.androidBg;
      }

      return AppAsset.bgDefaultNews;
    }

    String themeNews(String theme) {
      String result = "All";
      if (theme == "android_developer") {
        result = 'Android';
      } else if (theme == 'web_developer') {
        result = 'Web';
      }
      return result;
    }

    return GetBuilder<CNews>(builder: (controller) {
      cNews.getNewsDetail(newsArg.id!);
      News news = controller.news;
      if (news == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      List<Likes> likes = news.likes??[];
      bool isLiked = likes.any((like) => like.id == cUser.data.id!);
      return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              toolbarNews(getNewsImage, context),
              headerNews(news, context, themeNews),
              descriptionNews(news),
            ],
          ),
          bottomNavigationBar: bottomMenuNews(context, isLiked,news));
    });
  }

  Material bottomMenuNews(BuildContext context, bool isLiked,News news) {
    return Material(
      elevation:
          0, // Hilangkan elevation bawaan Material untuk menggunakan custom shadow
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna shadow
                spreadRadius: 2, // Radius penyebaran shadow
                blurRadius: 10, // Radius blur shadow
                offset: const Offset(0, -10), // Posisi shadow (ke atas)
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: BaseButton(
                    isExpand: true,
                      label: "Show Comment",
                      onTap: () {
                        showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return bottomSheetComment(context);
                            });
                      }
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    Likes like = Likes(
                      id: cUser.data.id!
                    );
                    if(isLiked){
                      cNews.unlikeComment(news.id!, like.toJson());
                      cNews.update();
                    }else{
                      cNews.likeComment(news.id!, like.toJson());
                      cNews.update();
                    }
                  },
                  child: Icon(
                    isLiked? Icons.favorite: Icons.favorite_border,
                    size: 40,
                  )
                )
              ],
            ),
          )),
    );
  }

  GetBuilder bottomSheetComment(BuildContext context) {
    return GetBuilder<CNews>(builder: (controller) {
      News news = controller.news;
      List<Comments> commentList = news.comments!;
      commentList.sort((a,b)=> b.createdAt!.compareTo(a.createdAt!));

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            decoration: const BoxDecoration(
              color: AppColor.backgroundScaffold,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: commentList.length,
                      itemBuilder: (context, index) {
                        Comments comment = commentList[index];
                        cNews.loadUsername(comment.id!);
                        if(commentList.isEmpty){
                          return const Center(child: Text("Tidak ada Komentar"),);
                        }else{
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AppAsset.person,
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              cNews.getUsername(comment.id!)?? "Unknown Users",
                                              style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(
                                              AppFormat.dateTime(comment.createdAt!.toIso8601String()),
                                              style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 10,
                                                        color: AppColor.bgCommentField
                                                    ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          comment.comment!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                            .copyWith(bottom: 20),
                    child: Stack(children: [
                      SizedBox(
                        height: 45,
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: AppColor.backgroundSearch,
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 12, 0, 8),
                            hintText: 'Write your comment',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(45), // Border kustom
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
                              Comments value = Comments(
                                  id: cUser.data.id!,
                                  comment: commentController.text,
                                  createdAt: DateTime.now()
                              );
                              if(commentController.text.isNotEmpty){
                                cNews
                                  .addComment(news.id!, value.toJson())
                                  .then((response) {
                                if (!response["success"]) {
                                  DInfo.dialogError(context, response['message']);
                                  DInfo.closeDialog(context);
                                } else {
                                  commentController.clear();
                                  FocusScope.of(context).unfocus();
                                  cNews.update();
                                }
                              });
                              }
                            },
                            borderRadius: BorderRadius.circular(45),
                            child: const SizedBox(
                              height: 45,
                              width: 45,
                              child: Center(
                                  child: Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            )),
      );
  });
  }

  Expanded descriptionNews(News news) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: AppColor.bgDescriptionNews),
        child: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(news.description ?? "")),
          ],
        ),
      ),
    );
  }

  Padding headerNews(
      News news, BuildContext context, String themeNews(String theme)) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                news.title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              Text(
                "${(news.likes??[]).length.toString()} likes",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(3)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Center(
                  child: Text(
                    themeNews(news.theme ?? ""),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack toolbarNews(String getNewsImage(), BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              getNewsImage(),
              fit: BoxFit.cover,
            )),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.backgroundScaffold),
              child: const Center(child: Icon(Icons.arrow_back)),
            ),
          ),
        )
      ],
    );
  }

}
