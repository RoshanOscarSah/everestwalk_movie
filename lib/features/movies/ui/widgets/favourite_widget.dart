import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:everestwalk_movie/common/cubit/common_state.dart';
import 'package:everestwalk_movie/features/movies/cubit/favourite_movie_cubit.dart';
import 'package:everestwalk_movie/features/movies/cubit/fetch_all_favourite_cubit.dart';
import 'package:everestwalk_movie/features/movies/models/movie_model.dart';
import 'package:everestwalk_movie/features/movies/resources/movie_repository.dart';
import 'package:everestwalk_movie/features/movies/ui/widgets/movie_card.dart';

class FavouriteWidget extends StatefulWidget {
  const FavouriteWidget({super.key});

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  @override
  void initState() {
    context.read<FetchAllFavoriteCubit>().fetchMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: Colors.orangeAccent,
        title: const Text(
          "Favourites",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        backgroundColor: Colors.black12,
      ),
      body: BlocBuilder<FetchAllFavoriteCubit, CommonState>(
          builder: (context, state) {
        if (state is CommonErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is CommonSuccessState<List<MovieModel>>) {
          if (state.item.isNotEmpty) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 290,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.item.length,
              itemBuilder: (BuildContext ctx, index) {
                return BlocProvider(
                  create: (context) => FavoriteCubit(
                    repository: context.read<MovieRepository>(),
                    initialValue: state.item[index].favorite,
                  ),
                  child: MovieCard(movie: state.item[index]),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Favourites added yet",
                style: TextStyle(
                  color: Colors.orangeAccent,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CupertinoActivityIndicator(
              color: Colors.orangeAccent,
            ),
          );
        }
      }),
    );
  }
}
