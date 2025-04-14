import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPathPage extends StatefulWidget {
  const DetailPathPage({super.key});

  @override
  State<DetailPathPage> createState() => _DetailPathPageState();
}

class _DetailPathPageState extends State<DetailPathPage> {
  @override
  Widget build(BuildContext context) {
    Roles role = ModalRoute.of(context)!.settings.arguments as Roles;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          '${role.name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                              AppFormat.showImageRoles(role.id!),
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black
                                        .withOpacity(1), // Opacity di kanan
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
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            AppFormat.formatPathName(
                                role.name ?? "Learning Path"),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              toolsPath(role),
              const SizedBox(
                height: 10,
              ),
              descriptionPath(role, context),
              const SizedBox(
                height: 10,
              ),
              levelsPath(role)
            ],
          )),
    );
  }

  ListView levelsPath(Roles role) {
    return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: role.levels!.length,
                itemBuilder: (context, index) {
                  Level level = role.levels![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.name!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      Text(
                        level.description!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: level.materials.length,
                        itemBuilder: (context, index) {
                            Materials materials = level.materials[index];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          materials.isExpanded == true
                                              ? const BorderRadius.vertical(
                                                  top: Radius.circular(10))
                                              : BorderRadius.circular(10),
                                      color: AppColor.secondary),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              materials.isExpanded =
                                                  !materials.isExpanded;
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
                                                        color: AppColor
                                                            .backgroundScaffold),
                                              ),
                                              Icon(
                                                materials.isExpanded == true
                                                    ? Icons
                                                        .keyboard_arrow_down
                                                    : Icons
                                                        .keyboard_arrow_right,
                                                color: AppColor
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
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
                                      child: Text.rich(
                                            TextSpan(
                                                text:
                                                    materials.recommendation!,
                                                style: const TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        final url = Uri.parse(
                                                            materials
                                                                .recommendation!);
                                                        try {
                                                          await launchUrl(url,
                                                              mode: LaunchMode
                                                                  .externalApplication);
                                                        } catch (e) {
                                                          DInfo.dialogError(
                                                              context,
                                                              'Tidak bisa membuka link');
                                                          DInfo.closeDialog(
                                                              context);
                                                        }
                                                }),
                                          ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 16,
                                )
                              ],
                            );
                          })
                    ],
                  );
                });
  }

  Text descriptionPath(Roles role, BuildContext context) {
    return Text(
      "${role.description}",
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
      textAlign: TextAlign.justify,
    );
  }

  Center toolsPath(Roles role) {
    return Center(
      child: SizedBox(
        height: 120,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: role.tools!.length,
            itemBuilder: (context, index) {
              Tool tool = role.tools![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          tool.image ?? "",
                          width: 70,
                          height: 70,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "${tool.name}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 12, fontWeight: FontWeight.w500),
                        softWrap: true,
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
