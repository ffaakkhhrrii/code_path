abstract class NewsDetailEvent{
  const NewsDetailEvent();
}

class FetchDetailNews extends NewsDetailEvent{
  String id;
  FetchDetailNews(this.id);
}

class ToggleLikeNews extends NewsDetailEvent{
  String newsId;
  Map<String,dynamic> like;
  ToggleLikeNews({required this.like,required this.newsId});
}

class AddComment extends NewsDetailEvent{
  String newsId;
  Map<String,dynamic> comment;
  AddComment({required this.comment,required this.newsId});
}