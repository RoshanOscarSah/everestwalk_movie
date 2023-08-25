import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:everestwalk_movie/common/cubit/common_state.dart';
import 'package:everestwalk_movie/features/movies/cubit/favourite_movie_cubit.dart';
import 'package:everestwalk_movie/features/movies/cubit/fetch_movie_list_bloc.dart';
import 'package:everestwalk_movie/features/movies/cubit/movie_event.dart';
import 'package:everestwalk_movie/features/movies/models/movie_model.dart';
import 'package:everestwalk_movie/features/movies/resources/movie_repository.dart';
import 'package:everestwalk_movie/features/movies/ui/pages/favourite_screen.dart';
import 'package:everestwalk_movie/features/movies/ui/widgets/movie_card.dart';

class MovieWidget extends StatefulWidget {
  const MovieWidget({super.key});

  @override
  State<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<FetchMovieListBloc>().add(FetchMovieEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black12,
          centerTitle: false,
          title: const Text(
            "EVERESTWALK Movies",
            style: TextStyle(
                color: Colors.orangeAccent, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                highlightColor: Colors.transparent,
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouriteScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 5), // add padding to adjust text
                        isDense: true,
                        hintStyle: const TextStyle(color: Colors.orangeAccent),
                        hintText: " Search Popular Movies ..",
                        errorStyle: const TextStyle(color: Colors.orangeAccent),
                        labelStyle: const TextStyle(color: Colors.orangeAccent),
                        helperStyle:
                            const TextStyle(color: Colors.orangeAccent),
                        prefixStyle:
                            const TextStyle(color: Colors.orangeAccent),
                        suffixStyle:
                            const TextStyle(color: Colors.orangeAccent),
                        counterStyle:
                            const TextStyle(color: Colors.orangeAccent),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.orangeAccent,
                            width: 2.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.orangeAccent,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        context.read<FetchMovieListBloc>().add(
                              FetchMovieEvent(
                                query: _searchController.text,
                              ),
                            );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 37,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context.read<FetchMovieListBloc>().add(
                                  FetchMovieEvent(
                                    query: _searchController.text,
                                  ),
                                );
                          },
                          child: const Center(
                              child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ))),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<FetchMovieListBloc, CommonState>(
                buildWhen: (previous, current) {
                  if (current is CommonLoadingState) {
                    return current.showLoading;
                  } else {
                    return true;
                  }
                },
                builder: (context, state) {
                  if (state is CommonErrorState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.orangeAccent),
                      ),
                    );
                  } else if (state is CommonSuccessState<List<MovieModel>>) {
                    if (state.item.isNotEmpty) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (_controller.position.userScrollDirection ==
                                  ScrollDirection.forward ||
                              _controller.position.userScrollDirection ==
                                  ScrollDirection.reverse) {
                            FocusScope.of(context).unfocus();
                          }

                          if (notification.metrics.pixels >=
                                  (notification.metrics.maxScrollExtent / 2) &&
                              _controller.position.userScrollDirection ==
                                  ScrollDirection.reverse) {
                            context.read<FetchMovieListBloc>().add(
                                LoadMoreMovieEvent(
                                    query: _searchController.text));
                          }
                          return true;
                        },
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: _controller,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
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
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No Movie found",
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
                },
              ),
            ),
          ],
        ));
  }
}
