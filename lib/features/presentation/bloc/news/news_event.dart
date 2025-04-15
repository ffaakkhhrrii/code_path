abstract class NewsEvent{
  const NewsEvent();
}

class FetchNewsData extends NewsEvent{
  const FetchNewsData();
}

class SearchNews extends NewsEvent{
  String searchText;
  SearchNews(this.searchText);
}