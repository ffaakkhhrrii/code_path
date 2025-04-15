import 'package:code_path/core/config/app_asset.dart';
import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/config/session.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/users.dart';
import 'package:code_path/features/presentation/bloc/home/home_bloc.dart';
import 'package:code_path/features/presentation/bloc/home/home_event.dart';
import 'package:code_path/features/presentation/bloc/home/home_state.dart';
import 'package:code_path/features/data/model/progress_user.dart'
    as progress_user;
import 'package:code_path/features/presentation/widget/dialog.dart';
import 'package:code_path/injection_app.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => s1()..add(const FetchDataUser()),
      child: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          header(context),
          const SizedBox(
            height: 25,
          ),
          trendingNews(context),
          const SizedBox(
            height: 25,
          ),
          bodyHome(context)
        ],
      ),
    );
  }

  bodyHome(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.users is DataSuccess && state.users!.data!.isAdmin == true) {
          if (state.usersCount == null || state.newsCount == null) {
            context.read<HomeBloc>().add(const FetchDataAdmin());
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.users is DataSuccess) {
            if (state.users!.data!.isAdmin != true) {
              return homeUsers(
                  context, state.progressUser!, state.users!.data!);
            } else {
              return state.usersCount != null && state.newsCount != null
                  ? homeAdmin(context, state.usersCount!, state.newsCount!)
                  : const Center(child: CircularProgressIndicator());
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  homeAdmin(BuildContext context, DataState<int> usersCount, DataState<int> newsCount) {
    if (usersCount is DataLoading || newsCount is DataLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (usersCount is DataSuccess) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            childAspectRatio: 5 / 3,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people,
                        size: 50,
                      ),
                      Text(
                        "${usersCount.data!} Users",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.newspaper,
                        size: 50,
                      ),
                      Text(
                        "${newsCount.data} News",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ));
    }

    if (usersCount is DataFailed) {
      return Center(
        child: Text(usersCount.error.toString()),
      );
    }
  }

  homeUsers(BuildContext context, DataState<progress_user.ProgressUser> progressUser, Users users) {
    if (progressUser is DataLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (progressUser is DataSuccess) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
              itemCount: progressUser.data!.levels!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, indexLevel) {
                progress_user.Level level =
                    progressUser.data!.levels![indexLevel];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: level.materials!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          progress_user.Materials materials =
                              level.materials![index];
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: materials.isExpanded == true
                                        ? const BorderRadius.vertical(
                                            top: Radius.circular(10))
                                        : BorderRadius.circular(10),
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
                                            materials.isExpanded =
                                                !materials.isExpanded;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                      color: materials.isDone ==
                                                              true
                                                          ? AppColor.secondary
                                                          : AppColor
                                                              .backgroundScaffold),
                                            ),
                                            Icon(
                                              materials.isExpanded == true
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_right,
                                              color: materials.isDone == true
                                                  ? AppColor.secondary
                                                  : AppColor.backgroundScaffold,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                                text: materials.recommendation!,
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
                                        Checkbox(
                                            checkColor: AppColor.secondary,
                                            value: materials.isDone,
                                            onChanged: (value) {
                                              if (value == null) return;

                                              context
                                                  .read<HomeBloc>()
                                                  .add(UpdateProgress(
                                                    levelIndex: indexLevel,
                                                    materialIndex: index,
                                                    value: value,
                                                  ));
                                            })
                                      ],
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
              },
            )
          ],
        ),
      );
    }

    if (progressUser is DataFailed) {
      return Center(
        child: Text(progressUser.error.toString()),
      );
    }
  }

  trendingNews(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.users is DataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.users is DataSuccess) {
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
                          state.users!.data!.isAdmin == true
                              ? AppAsset.bgDefaultNews
                              : AppFormat.showImageRoles(
                                  state.users!.data!.role!),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent,
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
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        state.users!.data!.isAdmin == true
                            ? 'Our Data\nToday'
                            : AppFormat.formatIdPathName(
                                state.users!.data!.role!),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (state.users!.data!.isAdmin == false)
                        SizedBox(
                          height: 30,
                          width: 90,
                          child: Material(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(8),
                            child: BlocConsumer<HomeBloc, HomeState>(
                                builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  context.read<HomeBloc>().add(MoveToRoleDetail(
                                      state.users!.data!.role!));
                                },
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
                              );
                            }, listener: (context, state) {
                              if (state.role is DataLoading) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (context.mounted) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const BasicDialog(
                                              message: "Loading",
                                              isLoading: true,
                                            ));
                                  }
                                });
                              }

                              if (state.role is DataSuccess) {
                                if (Navigator.of(context, rootNavigator: true)
                                    .canPop()) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                }
                                Navigator.pushNamed(
                                    context, AppRoute.detailRoles,
                                    arguments: state.role!.data!);
                                context
                                    .read<HomeBloc>()
                                    .add(AdditionalHandleState());
                              }

                              if (state.role is DataFailed) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (context.mounted) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          });
                                          return BasicDialog(
                                            message:
                                                state.role!.error.toString(),
                                          );
                                        });
                                  }
                                });
                              }
                            }),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state.users is DataFailed) {
          return Center(
            child: Text(state.users!.error.toString()),
          );
        }

        return const SizedBox();
      },
    );
  }

  header(BuildContext context) {
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
                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  if (state.users is DataSuccess) {
                    return Text(
                      'Hi, ${state.users!.data!.name}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColor.secondary,
                          fontSize: 26,
                          fontWeight: FontWeight.w700),
                    );
                  }
                  return const SizedBox();
                }),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  color: AppColor.primary,
                  child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.powerOff),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Apakah anda ingin keluar?"),
                                content: const Text("Pilih aksi"),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            SystemNavigator.pop();
                                          },
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      AppColor.secondary)),
                                          child: const Text("Keluar")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                AppRoute.signin,
                                                (route) => false);
                                            Session.clearUser();
                                          },
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      AppColor.secondary)),
                                          child: const Text("Logout"))
                                    ],
                                  )
                                ],
                              );
                            });
                      })),
            )
          ],
        ));
  }
}
