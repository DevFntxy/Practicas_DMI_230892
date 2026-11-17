import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/favorite_movie_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterCard extends StatelessWidget {
  final Movie movie;

  const MoviePosterCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: () => context.push('/movie/${movie.id}'),
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.movie_outlined, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: FavoriteMovieButton(movie: movie),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
