import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/presentation/bloc/path/path_bloc.dart';
import 'package:code_path/features/presentation/bloc/path/path_event.dart';
import 'package:code_path/features/presentation/bloc/path/path_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/injection_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PathMenu extends StatefulWidget {
  const PathMenu({super.key});

  @override
  State<PathMenu> createState() => _PathMenuState();
}

class _PathMenuState extends State<PathMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PathBloc>(
      create: (context) => s1()..add(const FetchPath()),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          header(context),
          Expanded(
              child: RefreshIndicator(
            child: listPath(),
            onRefresh: () async {
              context.read<PathBloc>().add(const FetchPath());
            },
          ))
        ],
      ),
    );
  }

  listPath() {
    return BlocBuilder<PathBloc,PathState>(builder: (context, state) {
      if(state.listRoles is DataLoading){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if(state.listRoles is DataSuccess){
        if (state.listRoles!.data!.isEmpty) {
          return const Center(
            child: Text("Belum ada path"),
          );
        } else {
          return ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.listRoles!.data!.length,
              itemBuilder: (context, index) {
                Roles roles = state.listRoles!.data![index];
                return Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(16),
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
                                  AppFormat.showImageRoles(roles.id!),
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
                              Text(
                                AppFormat.formatPathName(
                                    roles.name ?? "Learning Path"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
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
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AppRoute.detailRoles,
                                          arguments: roles);
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
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              });
        }
      }

      return const SizedBox();
    });
  }

  Padding header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Path',
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
    return BlocBuilder<PathBloc,PathState>(
      builder: (context,state){
        if(state.users is DataSuccess){
          if (state.users!.data!.isAdmin == true) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.addPath);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.secondary),
                child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
            );
          } else {
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: AppColor.secondary),
              child: const Center(
                  child: Icon(
                    Icons.space_dashboard,
                    size: 30,
                    color: Colors.white,
                  )),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
