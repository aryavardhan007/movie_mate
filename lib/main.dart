import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_mate/presentation/pages/home_page.dart';
import 'data/datasources/local/movie_local_datasource.dart';
import 'data/datasources/remote/movie_remote_datasource.dart';
import 'data/models/movie_model.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/repositories/movie_repository.dart';
import 'presentation/bloc/movie/movie_bloc.dart';
import 'presentation/bloc/movie/movie_event.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  final movieBox = await Hive.openBox<MovieModel>('movies');

  final remoteDataSource = MovieRemoteDataSource();
  final localDataSource = MovieLocalDataSource(movieBox: movieBox);
  final movieRepository = MovieRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(MyApp(movieRepository: movieRepository));
}

class MyApp extends StatelessWidget {
  final MovieRepository movieRepository;

  const MyApp({super.key, required this.movieRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(
        repository: movieRepository,
      )..add(const LoadMovies()),
      child: MaterialApp(
        title: 'Movie Mate',
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
