import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_format.dart';
import 'package:code_path/controller/c_admin.dart';
import 'package:code_path/controller/c_roles.dart';
import 'package:code_path/model/news.dart';
import 'package:code_path/widget/base_button.dart';
import 'package:code_path/widget/base_text_field.dart';
import 'package:d_info/d_info.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  String? selectedRole;

  final cAdmin = Get.put(CAdmin());
  final cRoles = Get.put(CRoles());

  final formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: const Text(
            'Add News',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: fieldAddPath(context));
  }

  GetBuilder<CRoles> fieldAddPath(BuildContext context) {
    return GetBuilder<CRoles>(builder: (controller) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BaseTextField(name: "Title", controller: titleTextController,),
                      const SizedBox(height: 20,),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
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
                          items: controller.listRoles
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
                            controller.getDataRole(value!);
                            setState(() {
                              selectedRole = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      BaseTextField(name: "Description", controller: descriptionTextController,type: TextInputType.multiline),
                      const SizedBox(height: 10,),
                      BaseButton(label: "Submit News", onTap: (){
                        if(formKey.currentState!.validate()){
                          News news = News(
                            createdAt: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                            createdBy: "admin",
                            description: descriptionTextController.text,
                            id: '',
                            likes: [],
                            theme: selectedRole,
                            title: titleTextController.text,
                            comments: []
                          );
                          cAdmin.addNews(news).then((result){
                            if(result["success"]){
                              DInfo.dialogSuccess(context, "Add News Success");
                              DInfo.closeDialog(context,
                              actionAfterClose: (){
                                Navigator.pop(context);
                              });
                            }else{
                              DInfo.dialogError(context, result["message"]);
                              DInfo.closeDialog(context);
                            }
                          });
                        }
                      },isExpand: true,)
                    ],
                  )),
            )
          ],
        );
      });
  }
}
