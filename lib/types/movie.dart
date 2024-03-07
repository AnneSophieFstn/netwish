import 'package:netwish/types/genre.dart';

class Movie {
  final String? title;
  final String? overview;
  final String? releaseDate;
  final String? posterPath;
  final double? voteAverage;
  final List<Genre>? genres;

  Movie({
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
  });
}
