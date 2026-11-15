class Book {
  final String id;
  final String title;
  final String author;
  final int year;
  final String? description; // Nullable: boleh kosong/null

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    this.description,
  });
}