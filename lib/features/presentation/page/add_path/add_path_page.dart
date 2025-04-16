import 'package:code_path/core/config/app_color.dart';
import 'package:code_path/core/config/app_format.dart';
import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/presentation/bloc/add_path/add_path_bloc.dart';
import 'package:code_path/features/presentation/bloc/add_path/add_path_event.dart';
import 'package:code_path/features/presentation/bloc/add_path/add_path_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/presentation/widget/base_button.dart';
import 'package:code_path/features/presentation/widget/base_text_field.dart';
import 'package:code_path/features/presentation/widget/dialog.dart';
import 'package:code_path/injection_app.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPathPage extends StatefulWidget {
  const AddPathPage({super.key});

  @override
  State<AddPathPage> createState() => _AddPathPageState();
}

class _AddPathPageState extends State<AddPathPage> {
  final formKey = GlobalKey<FormState>();

  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  // for Tools
  final nameToolsTextController = TextEditingController();
  final imageToolsTextController = TextEditingController();

  // for Level
  final nameLevelTextController = TextEditingController();
  final descriptionLevelTextController = TextEditingController();

  // for Material
  final nameMaterialTextController = TextEditingController();
  final recommendationLevelTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPathBloc>(
        create: (context) => s1(),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                title: const Text(
                  'Add Path',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoute.home);
                    },
                    icon: const Icon(Icons.arrow_back))),
            body: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          BaseTextField(
                            name: "Title",
                            controller: nameTextController,
                          ),
                          const SizedBox(height: 10),
                          BaseTextField(
                            name: "Description",
                            controller: descriptionTextController,
                            type: TextInputType.multiline,
                          ),
                          const SizedBox(height: 10),
                          BaseButton(
                            label: "Add Tools",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  final screenHeight =
                                      MediaQuery.of(context).size.height;
                                  return _dialogAddTools(screenHeight, context);
                                },
                              );
                            },
                            isExpand: true,
                          ),
                          const SizedBox(height: 10),
                          listTools(),
                          const SizedBox(height: 10),
                          BaseButton(
                            label: "Add Level",
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    final screenHeight =
                                        MediaQuery.of(context).size.height;
                                    return _dialogAddLevels(
                                        screenHeight, context);
                                  });
                            },
                            isExpand: true,
                          ),
                          const SizedBox(height: 10),
                          listLevels(),
                          const SizedBox(height: 10),
                          BlocConsumer<AddPathBloc, AddPathState>(
                              builder: (context, state) {
                            return BaseButton(
                              label: "Submit",
                              onTap: () {
                                Roles roles = Roles(
                                    id: AppFormat.generateIdRoles(
                                        nameTextController.text),
                                    name: nameTextController.text,
                                    description: descriptionTextController.text,
                                    levels: state.levels!,
                                    tools: state.tools!);
                                context
                                    .read<AddPathBloc>()
                                    .add(SubmitPath(roles));
                              },
                              isExpand: true,
                            );
                          }, listener: (context, state) {
                            if (Navigator.of(context, rootNavigator: true)
                                .canPop()) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }

                            if (state.resultSubmitPath is DataLoading) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
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

                            if (state.resultSubmitPath is DataSuccess) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              AppRoute.home,
                                              (route) => false);
                                        });
                                        return BasicDialog(
                                          message:
                                              state.resultSubmitPath!.data!,
                                        );
                                      });
                                }
                              });
                            }

                            if (state.resultSubmitPath is DataFailed) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        });
                                        return BasicDialog(
                                          message:
                                              state.resultSubmitPath.toString(),
                                        );
                                      });
                                }
                              });
                            }
                          })
                        ],
                      )),
                )
              ],
            ),
          );
        }));
  }

  _dialogAddLevels(double screenHeight, BuildContext dialogContext) {
    return AlertDialog(
      title: const Text("Add Level"),
      content: SizedBox(
        height: screenHeight * 0.2,
        child: Column(
          children: [
            BaseTextField(
                name: "Name Level", controller: nameLevelTextController),
            const SizedBox(height: 10),
            BaseTextField(
                name: "Description Level",
                controller: descriptionLevelTextController),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameLevelTextController.text.isNotEmpty &&
                    descriptionLevelTextController.text.isNotEmpty) {
                  dialogContext.read<AddPathBloc>().add(UpdateLevels(
                      name: nameLevelTextController.text,
                      description: descriptionLevelTextController.text));
                  Navigator.pop(dialogContext);
                  nameLevelTextController.clear();
                  descriptionLevelTextController.clear();
                } else {
                  DInfo.toastError("Isi field!!");
                }
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              child: const Text("Add"),
            )
          ],
        )
      ],
    );
  }

  _dialogAddTools(double screenHeight, BuildContext dialogContext) {
    return AlertDialog(
      title: const Text("Add Tools"),
      content: SizedBox(
        height: screenHeight * 0.2,
        child: Column(
          children: [
            BaseTextField(
                name: "Name Tools", controller: nameToolsTextController),
            const SizedBox(height: 10),
            BaseTextField(
                name: "Image Tools", controller: imageToolsTextController),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameToolsTextController.text.isNotEmpty &&
                    imageToolsTextController.text.isNotEmpty) {
                  dialogContext.read<AddPathBloc>().add(UpdateTools(
                        name: nameToolsTextController.text,
                        image: imageToolsTextController.text,
                      ));
                  Navigator.pop(dialogContext);
                  nameToolsTextController.clear();
                  imageToolsTextController.clear();
                } else {
                  DInfo.toastError("Isi field!!");
                }
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColor.secondary),
              ),
              child: const Text("Add"),
            )
          ],
        )
      ],
    );
  }

  listTools() {
    return BlocBuilder<AddPathBloc, AddPathState>(builder: (context, state) {
      if (state.tools != null && state.tools!.isNotEmpty) {
        return ListView.builder(
          itemCount: state.tools!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Tool tool = state.tools![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${tool.name}'),
                    InkWell(
                      onTap: () {
                        context.read<AddPathBloc>().add(DeleteTools(index));
                      },
                      child: const Icon(
                        Icons.delete,
                        color: AppColor.secondary,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
      return const SizedBox();
    });
  }

  listLevels() {
    return BlocBuilder<AddPathBloc, AddPathState>(builder: (context, state) {
      if (state.levels!.isNotEmpty) {
        return ListView.builder(
          itemCount: state.levels!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Level level = state.levels![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${level.name}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              final screenHeight =
                                  MediaQuery.of(context).size.height;
                              return _dialogAddMaterials(
                                  screenHeight, context, index);
                            },
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColor.secondary,
                        ),
                      )
                    ],
                  ),
                  listMaterials(level.materials, context, index)
                ],
              ),
            );
          },
        );
      }
      return const SizedBox();
    });
  }

  listMaterials(
      List<Materials> materials, BuildContext materialContext, int levelIndex) {
    return materials.isNotEmpty
        ? ListView.builder(
            itemCount: materials.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Materials material = materials[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${material.name}'),
                      InkWell(
                        onTap: () {
                          materialContext.read<AddPathBloc>().add(
                              DeleteMaterials(
                                  materialIndex: index,
                                  levelIndex: levelIndex));
                        },
                        child: const Icon(
                          Icons.delete,
                          color: AppColor.secondary,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: Text(""));
  }

  _dialogAddMaterials(
      double screenHeight, BuildContext dialogContext, int levelIndex) {
    return AlertDialog(
      title: const Text("Add Materials"),
      content: SizedBox(
        height: screenHeight * 0.2,
        child: Column(
          children: [
            BaseTextField(
                name: "Name Material", controller: nameMaterialTextController),
            const SizedBox(height: 10),
            BaseTextField(
                name: "Link Recommendation",
                controller: recommendationLevelTextController),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColor.secondary)),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameMaterialTextController.text.isNotEmpty &&
                    recommendationLevelTextController.text.isNotEmpty) {
                  dialogContext.read<AddPathBloc>().add(UpdateMaterials(
                      name: nameMaterialTextController.text,
                      recommendation: recommendationLevelTextController.text,
                      index: levelIndex));
                  Navigator.pop(dialogContext);
                  nameMaterialTextController.clear();
                  recommendationLevelTextController.clear();
                } else {
                  DInfo.toastError("Isi field!!");
                }
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColor.secondary)),
              child: const Text("Add"),
            ),
          ],
        )
      ],
    );
  }
}
