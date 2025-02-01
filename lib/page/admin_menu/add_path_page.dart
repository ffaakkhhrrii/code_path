import 'package:code_path/config/app_color.dart';
import 'package:code_path/config/app_format.dart';
import 'package:code_path/controller/c_admin.dart';
import 'package:code_path/controller/c_roles.dart';
import 'package:code_path/model/roles.dart';
import 'package:code_path/widget/base_button.dart';
import 'package:code_path/widget/base_text_field.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    
  final List<Tool> tools = [];
  final List<Level> levels = [];

  final cRoles = Get.put(CRoles());
  final cAdmin = Get.put(CAdmin());

  @override
  Widget build(BuildContext context) {
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
        ),
      body: ListView(
        shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                      BaseTextField(name: "Title", controller: nameTextController,),
                      const SizedBox(height: 10,),
                      BaseTextField(name: "Description", controller: descriptionTextController,type: TextInputType.multiline,),
                      const SizedBox(height: 10,),
                      BaseButton(label: "Add Tools", onTap: (){
                        showDialog(context: context, builder: (context){
                        final screenHeight = MediaQuery.of(context).size.height;
                        return AlertDialog(
                          title: const Text("Add Tools"),
                          content: Container(
                            height: screenHeight * 0.2,
                            child: Column(
                              children: [
                                BaseTextField(name: "Name Tools", controller: nameToolsTextController),
                                const SizedBox(height: 10,),
                                BaseTextField(name: "Image Tools", controller: imageToolsTextController),
                              ],
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                  child: const Text("Cancel")
                                ),
                                TextButton(
                                  onPressed: (){
                                    if(nameToolsTextController.text.isNotEmpty && imageToolsTextController.text.isNotEmpty){
                                      setState(() {
                                        tools.add(Tool(
                                          name: nameToolsTextController.text,
                                          image: imageToolsTextController.text
                                        ));
                                      });
                                      Navigator.pop(context);
                                      nameToolsTextController.clear();
                                      imageToolsTextController.clear();
                                    }else{
                                      DInfo.toastError("Isi field!!");
                                    }
                                  },
                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                  child: const Text("Add")
                                )
                              ],
                            )
                          ],
                        );
                      });
                      },isExpand: true,),
                      const SizedBox(height: 10,),
                      listTools(tools),
                      const SizedBox(height: 10,),
                      BaseButton(label: "Add Level", onTap: (){
                        showDialog(context: context, builder: (context){
                        final screenHeight = MediaQuery.of(context).size.height;
                        return AlertDialog(
                          title: const Text("Add Level"),
                          content: Container(
                            height: screenHeight * 0.2,
                            child: Column(
                              children: [
                                BaseTextField(name: "Name Level", controller: nameLevelTextController),
                                const SizedBox(height: 10,),
                                BaseTextField(name: "Description Level", controller: descriptionLevelTextController),
                              ],
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                  child: const Text("Cancel")
                                ),
                                TextButton(
                                  onPressed: (){
                                    if(nameLevelTextController.text.isNotEmpty && descriptionLevelTextController.text.isNotEmpty){
                                      setState(() {
                                        levels.add(
                                          Level(
                                            name: nameLevelTextController.text,
                                            description: descriptionLevelTextController.text,
                                            materials: []
                                          )
                                        );
                                      });
                                      Navigator.pop(context);
                                      nameLevelTextController.clear();
                                      descriptionLevelTextController.clear();
                                    }else{
                                      DInfo.toastError("Isi field!!");
                                    }
                                  },
                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                  child: const Text("Add")
                                )
                              ],
                            )
                          ],
                        );
                      });
                      },isExpand: true,),
                      const SizedBox(height: 10,),
                      listLevels(levels),
                      const SizedBox(height: 10,),
                      BaseButton(label: "Submit", onTap: (){
                        if(formKey.currentState!.validate()){
                            Roles role = Roles(
                              id: AppFormat.generateIdRoles(nameTextController.text),
                              name: nameTextController.text,
                              description: descriptionTextController.text,
                              levels: levels,
                              tools: tools
                            );
                            cAdmin.addPath(role).then((result){
                              if(result["success"]){
                                DInfo.dialogSuccess(context, "Add Roles Success");
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
        ),
    );
  }

  Widget listTools(List<Tool> tools){
    return tools.isNotEmpty
          ? ListView.builder(
                itemCount: tools.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Tool tool = tools[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${tool.name}'),
                          InkWell(
                            onTap: (){
                              setState(() {
                                tools.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: AppColor.secondary,
                            ),
                          )
                        ],
                      )
                    ),
                  );
                },
              )
          : const Center(
              child: Text(""),
    );
  }

  Widget listLevels(List<Level> levels){
    return levels.isNotEmpty
          ? ListView.builder(
                itemCount: levels.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Level level = levels[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${level.name}',style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14
                              ),),
                              InkWell(
                                onTap: (){
                                  showDialog(context: context, builder: (context){
                                    final screenHeight = MediaQuery.of(context).size.height;
                                    return AlertDialog(
                                      title: const Text("Add Materials"),
                                      content: Container(
                                        height: screenHeight * 0.2,
                                        child: Column(
                                          children: [
                                            BaseTextField(name: "Name Material", controller: nameMaterialTextController),
                                            const SizedBox(height: 10,),
                                            BaseTextField(name: "Link Recommendation", controller: recommendationLevelTextController),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                              child: const Text("Cancel")
                                            ),
                                            TextButton(
                                              onPressed: (){
                                                if(nameMaterialTextController.text.isNotEmpty && recommendationLevelTextController.text.isNotEmpty){
                                                  setState(() {
                                                    levels[index].materials.add(Materials(
                                                      name: nameMaterialTextController.text,
                                                      recommendation: recommendationLevelTextController.text
                                                    ));
                                                  });
                                                  Navigator.pop(context);
                                                  nameMaterialTextController.clear();
                                                  recommendationLevelTextController.clear();
                                                }else{
                                                  DInfo.toastError("Isi field!!");
                                                }
                                              },
                                              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColor.secondary)), 
                                              child: const Text("Add")
                                            )
                                          ],
                                        )
                                      ],
                                    );
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: AppColor.secondary,
                                ),
                              )
                            ],
                        ),
                        listMaterials(level.materials)
                      ],
                    )
                  );
                },
              )
          : const Center(
              child: Text(""),
    );
  }
  
  Widget listMaterials(List<Materials> materials){
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${material.name}'),
                          InkWell(
                            onTap: (){
                              setState(() {
                                materials.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: AppColor.secondary,
                            ),
                          )
                        ],
                      )
                    ),
                  );
                },
              )
          : const Center(
              child: Text(""),
    );
  }
}