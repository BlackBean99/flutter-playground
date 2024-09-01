class WebtoonEpisodeModel {
  final String id, title, rating, date;

  WebtoonEpisodeModel.fromJson(
      Map<String, dynamic> json) //title, thumb, id 등을 초기화하는 편리한 구문일 뿐
      : id = json['id'],
        rating = json['rating'],
        title = json['title'],
        date = json['date'];
  //WebtoonModel title은 JSON의 title로 초기화되고...
}
