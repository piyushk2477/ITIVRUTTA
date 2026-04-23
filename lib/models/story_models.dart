class Story {
  final int id;
  final String title;
  final String description;
  final String coverImage;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
  });

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      coverImage: map['cover_image'],
    );
  }
}