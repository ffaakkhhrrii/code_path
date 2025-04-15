import 'package:code_path/core/config/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config/app_color.dart';
import '../bloc/news/news_bloc.dart';
import '../bloc/news/news_event.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Stack(
        children: [
          SizedBox(
            height: 45,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: AppColor.backgroundSearch,
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
              child: InkWell(
                onTap: () {
                  if(controller.text.isEmpty){
                    context.read<NewsBloc>().add(const FetchNewsData());
                  }else{
                    context.read<NewsBloc>().add(SearchNews(controller.text));
                  }
                },
                borderRadius: BorderRadius.circular(45),
                child: const SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(AppAsset.iconSearch),
                      color: AppColor.backgroundScaffold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
