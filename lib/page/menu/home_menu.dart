import 'package:code_path/config/app_asset.dart';
import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_format.dart';
import 'package:code_path/controller/c_user.dart';
import 'package:code_path/model/progress_user.dart';
import 'package:code_path/source/user_source.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  final cUser = Get.put(CUser());

  @override
  void initState() {
    cUser.getProgress(cUser.data.id!, cUser.data.role!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 25,
        ),
        header(context),
        //searchField(),
        const SizedBox(
          height: 25,
        ),
        trendingNews(context),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<CUser>(builder: (_) {
            if (_.progressUser.levels == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (_.progressUser.levels!.isEmpty) {
              return const Center(
                child: Text('Data tidak tersedia'),
              );
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    itemCount: _.progressUser.levels!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, indexLevel) {
                      Level level = _.progressUser.levels![indexLevel];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              itemCount: level.materials!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Materials materials = level.materials![index];
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: materials.isExpanded == true ? const BorderRadius.vertical(top: Radius.circular(10)): BorderRadius.circular(10),
                                          color: materials.isDone == true
                                              ? AppColor.primary
                                              : AppColor.secondary),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  materials.isExpanded = !materials.isExpanded;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    materials.name!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: materials
                                                                        .isDone ==
                                                                    true
                                                                ? AppColor
                                                                    .secondary
                                                                : AppColor
                                                                    .backgroundScaffold),
                                                  ),
                                                  Icon(
                                                    materials.isExpanded == true
                                                          ? Icons
                                                              .keyboard_arrow_down
                                                          : Icons
                                                              .keyboard_arrow_right,
                                                      color: materials
                                                                        .isDone ==
                                                                    true
                                                                ? AppColor
                                                                    .secondary
                                                                : AppColor
                                                                    .backgroundScaffold,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (materials.isExpanded)
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: materials.recommendation!,
                                                  style: const TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                                  recognizer: TapGestureRecognizer()
                                                  ..onTap = () async{
                                                    final url = Uri.parse(materials.recommendation!);
                                                    print("Trying to launch URL: $url");
                                                    try{
                                                      await launchUrl(url,mode: LaunchMode.externalApplication);
                                                    }catch(e){
                                                      DInfo.dialogError(context, 'Tidak bisa membuka link');
                                                      DInfo.closeDialog(context);
                                                    }
                                                  }
                                                ),
                                              ),
                                              Checkbox(
                                                value: materials.isDone, 
                                                onChanged: (value){
                                                  setState(() {  
                                                    materials.isDone = value!;
                                                    cUser.updateProgress(
                                                      _.data.id!, 
                                                      _.progressUser.id!,
                                                      indexLevel,
                                                      index,
                                                      value
                                                    );
                                                  });
                                                }
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 16,)
                                  ],
                                );
                              })
                        ],
                      );
                    },
                  )
                ],
              );
            }
          }),
        )
      ],
    );
  }

  Container trendingNews(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 5 / 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAsset.bgDefaultNews,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.9), // Opacity di kanan
                          Colors.transparent, // Transparan di kiri
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending News\nFor You',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 30,
                  width: 90,
                  child: Material(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: null,
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          'View',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColor.secondary),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColor.backgroundSearch,
          suffixIconColor: Colors.grey,
          suffixIcon: const ImageIcon(AssetImage(AppAsset.iconSearch)),
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
          hintText: 'Search',
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Border kustom
            borderSide: BorderSide.none, // Tidak ada garis
          ),
        ),
      ),
    );
  }

  Padding header(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormat.date(DateTime.now().toIso8601String()),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColor.titleDate,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Hi, ${cUser.data.name}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColor.secondary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: AppColor.primary,
                child: Image.asset(
                  AppAsset.person,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }
}
