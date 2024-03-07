import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netwish/types/genre.dart';
import 'package:netwish/types/movie.dart';

final base_url = 'https://api.themoviedb.org/3/';
final api_key = '26a145d058cf4d1b17cbf084ddebedec';

Future<List<Movie>> getMovies(String movieName, List<Genre> genres) async {
  var query = '';
  if (movieName.isNotEmpty) {
    movieName = movieName.replaceAll(' ', '+');
    query =
        '${base_url}/search/movie?api_key=$api_key&query=$movieName&language=fr-FR&page=1';
  } else {
    query = '${base_url}movie/popular?api_key=$api_key&language=fr-FR&page=1';
  }

  final response = await http.get(Uri.parse(query));
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final List<Movie> movies = [];
    for (var movie in result['results']) {
      List<Genre> movieGenres = [];
      for (var genre_id in movie['genre_ids']) {
        final Genre genre = genres.firstWhere(
          (element) => element.id == genre_id,
          orElse: () => Genre(id: 0, name: 'Unknown'),
        );

        if (genre.id != 0) {
          movieGenres.add(genre);
        }
      }

      movies.add(
        Movie(
          title: movie['title'],
          overview: movie['overview'],
          releaseDate: movie['release_date'],
          posterPath: movie['poster_path'],
          voteAverage: movie['vote_average'].toDouble(),
          genres: movieGenres,
        ),
      );
    }
    return movies;
  } else {
    throw Exception("Failed to load movies");
  }
}

Future<List<Genre>> getGenres() async {
  final query = '${base_url}genre/movie/list?api_key=$api_key&language=fr-FR';
  final response = await http.get(Uri.parse(query));

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final List<Genre> genres = [];
    for (var genre in result['genres']) {
      genres.add(Genre(
        id: genre['id'],
        name: genre['name'],
      ));
    }
    return genres;
  } else {
    throw Exception('Failed to load genres');
  }
}
