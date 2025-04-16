import 'package:code_path/core/config/app_route.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/presentation/bloc/add_news/add_news_bloc.dart';
import 'package:code_path/features/presentation/bloc/add_news/add_news_event.dart';
import 'package:code_path/features/presentation/bloc/add_news/add_news_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/presentation/widget/base_button.dart';
import 'package:code_path/features/presentation/widget/base_text_field.dart';
import 'package:code_path/features/presentation/widget/dialog.dart';
import 'package:code_path/injection_app.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  String? selectedRole;

  final formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddNewsBloc>(
      create: (context) => s1()..add(const FetchThemeData()),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: const Text(
              'Add News',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoute.home,
                      arguments: 2);
                }, icon: const Icon(Icons.arrow_back)),
          ),
          body: fieldAddPath(context)),
    );
  }

  fieldAddPath(BuildContext context) {
    return BlocBuilder<AddNewsBloc, AddNewsState>(builder: (context, state) {
      if (state.roles is DataSuccess) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BaseTextField(
                        name: "Title",
                        controller: titleTextController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _dropdownAddNews(context, state),
                      const SizedBox(
                        height: 10,
                      ),
                      BaseTextField(
                          name: "Description",
                          controller: descriptionTextController,
                          type: TextInputType.multiline),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<AddNewsBloc, AddNewsState>(
                          builder: (context, state) {
                        return BaseButton(
                          label: "Submit News",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              News news = News(
                                  createdAt: DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()),
                                  createdBy: "admin",
                                  description: descriptionTextController.text,
                                  id: '',
                                  likes: [],
                                  theme: selectedRole,
                                  title: titleTextController.text,
                                  comments: []);
                              context.read<AddNewsBloc>().add(SubmitNews(news));
                            }
                          },
                          isExpand: true,
                        );
                      }, listener: (context, state) {
                        if (Navigator.of(context, rootNavigator: true)
                            .canPop()) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }

                        if (state.resultSubmit is DataLoading) {
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

                        if (state.resultSubmit is DataSuccess) {
                          titleTextController.clear();
                          descriptionTextController.clear();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, AppRoute.home,
                                            arguments: 2);
                                      }
                                    });
                                    return BasicDialog(
                                      message: state.resultSubmit!.data!,
                                    );
                                  });
                            }
                          });
                        }

                        if (state is DataFailed) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                    return BasicDialog(
                                      message: state.resultSubmit.toString(),
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
        );
      }
      return const SizedBox();
    });
  }

  DropdownButtonHideUnderline _dropdownAddNews(
      BuildContext context, AddNewsState state) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        hint: Text(
          'Theme',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: state.roles!.data!
            .map((role) => DropdownMenuItem<String>(
                  value: role.id!,
                  child: Text(role.name!),
                ))
            .toList(),
        value: selectedRole,
        onSaved: (String? value) {
          selectedRole = value;
        },
        validator: (value) {
          if (value == null || value == '') {
            return "Role harus diisi";
          }
          return null;
        },
        onChanged: (String? value) {
          setState(() {
            selectedRole = value;
          });
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
    );
  }
}
