import 'package:cinemapedia/domain/entities/movie_genre.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_genres_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/app_sidebar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  static const name = 'categories-screen';

  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  MovieGenre? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    // TODO: idioma
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedGenre?.name ?? 'Categorías'),
        leading: _selectedGenre == null
            ? null
            : IconButton(
                tooltip: 'Volver a categorías',
                onPressed: () => setState(() => _selectedGenre = null),
                icon: const Icon(Icons.arrow_back),
              ),
      ),
      drawer: const AppSidebar(),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
      body: _selectedGenre == null
          ? _buildGenres()
          : _buildMovies(_selectedGenre!),
    );
  }

  Widget _buildGenres() {
    final genres = ref.watch(movieGenresProvider);

    return genres.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _ErrorMessage(
        message: 'No se pudieron cargar las categorías.',
        onRetry: () => ref.invalidate(movieGenresProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No hay categorías disponibles.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final genre = items[index];

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() => _selectedGenre = genre),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      genre.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMovies(MovieGenre genre) {
    final movies = ref.watch(moviesByGenreProvider(genre.id));

    return movies.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _ErrorMessage(
        message: 'No se pudieron cargar las películas.',
        onRetry: () => ref.invalidate(moviesByGenreProvider(genre.id)),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text('No hay películas disponibles en esta categoría.'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            childAspectRatio: 0.52,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => MoviePosterCard(movie: items[index]),
        );
      },
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // TODO: idioma
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}
