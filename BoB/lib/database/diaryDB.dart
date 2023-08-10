class Diary {
  final String date;
  final String title;
  final String content;
  final String? image;

  Diary({required this.date, required this.title, required this.content, this.image});

  factory Diary.fromMap(Map<String, dynamic> json) => Diary(
      date: json['date'],
      title: json['title'],
      content: json['content'],
      image: json['image']
  );

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'content': content,
      'image': image
    };
  }
}