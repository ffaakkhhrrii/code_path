import 'package:code_path/features/data/model/news.dart';

abstract class AddNewsEvent{
  const AddNewsEvent();
}

class FetchThemeData extends AddNewsEvent{
  const FetchThemeData();
}

class SubmitNews extends AddNewsEvent{
  News news;
  SubmitNews(this.news);
}