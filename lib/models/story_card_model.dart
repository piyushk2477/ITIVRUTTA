class StoryCard {

  final int id;
  final int storyId;
  final String text;
  final String image;

  StoryCard({
    required this.id,
    required this.storyId,
    required this.text,
    required this.image,
  });

  factory StoryCard.fromMap(Map<String, dynamic> map) {
    return StoryCard(
      id: map['id'],
      storyId: map['story_id'],
      text: map['text'],
      image: map['image'],
    );
  }

}