import 'package:code_path/core/config/app_asset.dart';
import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/presentation/bloc/news_detail/news_detail_bloc.dart';
import 'package:code_path/features/presentation/bloc/news_detail/news_detail_event.dart';
import 'package:code_path/features/presentation/bloc/news_detail/news_detail_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/presentation/widget/base_button.dart';
import 'package:code_path/features/presentation/widget/dialog.dart';
import 'package:code_path/injection_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailNewsPage extends StatefulWidget {
  const DetailNewsPage({super.key});

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    News newsArg = ModalRoute.of(context)!.settings.arguments as News;

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

    return BlocProvider<NewsDetailBloc>(
        create: (context) => s1()..add(FetchDetailNews(newsArg.id!)),
        child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                toolbarNews(getNewsImage, context),
                headerNews(context, themeNews),
                descriptionNews(),
              ],
            ),
            bottomNavigationBar: bottomMenuNews(context)));
  }

  bottomMenuNews(BuildContext context) {
    return BlocBuilder<NewsDetailBloc, NewsDetailState>(
        builder: (blocContext, state) {
      if (state.news is DataSuccess) {
        return Material(
          elevation: 0,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -10),
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
                                context: blocContext,
                                builder: (BuildContext commentContext) {
                                  return bottomSheetComment(blocContext,
                                      state.news!.data!, state.users!.id!, state.users!.name!);
                                });
                          }),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    BlocConsumer<NewsDetailBloc, NewsDetailState>(
                        builder: (context, state) {
                      return InkWell(
                          onTap: () {
                            Likes like = Likes(id: state.users!.id);
                            context.read<NewsDetailBloc>().add(ToggleLikeNews(
                                like: like.toJson(),
                                newsId: state.news!.data!.id!));
                          },
                          child: Icon(
                            state.isLiked!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 40,
                          ));
                    }, listener: (context, state) {
                      if (state.isClicked is DataFailed) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  });
                                  return BasicDialog(
                                    message: state.isClicked!.error.toString(),
                                  );
                                });
                          }
                        });
                      }
                    })
                  ],
                ),
              )),
        );
      }
      return const SizedBox();
    });
  }

  bottomSheetComment(BuildContext context, News newsData, String userId, String name) {
    News news = newsData;
    List<Comments> commentList = news.comments!;
    commentList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocProvider.value(
        value: BlocProvider.of<NewsDetailBloc>(context),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: AppColor.backgroundScaffold,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              children: [
                _commentContainer(context),
                const SizedBox(height: 10),
                _fieldComment(userId, news, context, name)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _fieldComment(String userId, News news, BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
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
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
              hintText: 'Write your comment',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(45),
              child: BlocConsumer<NewsDetailBloc, NewsDetailState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        Comments value = Comments(
                            id: userId,
                            name: name,
                            comment: commentController.text,
                            createdAt: DateTime.now());
                        if (commentController.text.isNotEmpty) {
                          context.read<NewsDetailBloc>().add(AddComment(comment: value.toJson(), newsId: news.id!));
                        }
                      },
                      borderRadius: BorderRadius.circular(45),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: Center(
                            child: Icon(
                              state.resultAddComment is DataLoading ? Icons.circle_outlined
                                  : Icons.send,
                              color: Colors.white,
                            )
                        ),
                      ),
                    );
                  }, listener: (context, state) {

                if (state.resultAddComment is DataSuccess){
                  commentController.clear();
                }
                if (state.resultAddComment is DataFailed) {
                  commentController.clear();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 1), () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            });
                            return BasicDialog(
                              message: state.resultAddComment!.error.toString(),
                            );
                          });
                    }
                  });
                }
              })),
        )
      ]),
    );
  }
  
  _commentContainer(BuildContext context) {
    return BlocBuilder<NewsDetailBloc,NewsDetailState>(
        builder: (context,state){
          if(state.news is DataLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state.news is DataSuccess){
            return Expanded(
              child: ListView.builder(
                itemCount: state.news!.data!.comments!.length,
                itemBuilder: (context, index) {
                  Comments comment = state.news!.data!.comments![index];

                  if (state.news!.data!.comments! == []) {
                    return const Center(
                      child: Text(
                          "Tidak ada Komentar"
                      ),
                    );
                  } else {
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
                                        comment.name ?? "...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        AppFormat.dateTime(
                                            comment.createdAt!.toIso8601String()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: AppColor.bgCommentField),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    comment.comment!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                        fontWeight: FontWeight.w400, fontSize: 12),
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
            );
          }

          return const SizedBox();
        }
    );
  }

  descriptionNews() {
    return BlocBuilder<NewsDetailBloc, NewsDetailState>(
        builder: (context, state) {
      if (state.news is DataLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.news is DataSuccess) {
        return Expanded(
          child: Container(
            decoration: const BoxDecoration(color: AppColor.bgDescriptionNews),
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Text(state.news!.data!.description ?? "")),
              ],
            ),
          ),
        );
      }

      return const SizedBox();
    });
  }

  headerNews(BuildContext context, String Function(String theme) themeNews) {
    return BlocBuilder<NewsDetailBloc, NewsDetailState>(
        builder: (context, state) {
      if (state.news is DataSuccess) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.news!.data!.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${(state.news!.data!.likes ?? []).length.toString()} likes",
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Center(
                      child: Text(
                        themeNews(state.news!.data!.theme ?? ""),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return const SizedBox();
    });
  }

  toolbarNews(String Function() getNewsImage, BuildContext context) {
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
