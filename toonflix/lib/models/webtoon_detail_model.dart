class WebtoonDetailModel {
  final String title, about, genre, age;

  WebtoonDetailModel.fromJson(
      Map<String, dynamic> json) //title, thumb, id 등을 초기화하는 편리한 구문일 뿐
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
  //WebtoonModel title은 JSON의 title로 초기화되고...
}
