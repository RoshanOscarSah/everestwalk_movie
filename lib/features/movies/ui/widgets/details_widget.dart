// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:everestwalk_movie/features/movies/resources/trailer_repo.dart';
import 'package:everestwalk_movie/features/movies/ui/pages/widgets/player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:everestwalk_movie/common/cubit/common_state.dart';
import 'package:everestwalk_movie/features/movies/cubit/favourite_movie_cubit.dart';
import 'package:everestwalk_movie/features/movies/cubit/fetch_all_favourite_cubit.dart';
import 'package:everestwalk_movie/features/movies/cubit/fetch_movie_list_bloc.dart';
import 'package:everestwalk_movie/features/movies/cubit/movie_event.dart';
import 'package:everestwalk_movie/features/movies/models/movie_model.dart';

class DetailsWidget extends StatefulWidget {
  final MovieModel movie;
  const DetailsWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  String response = '';
  @override
  void initState() {
    getVideoId();

    super.initState();
  }

  void getVideoId() async {
    response = await getTrailer(widget.movie.id);
  }

  @override
  void dispose() {
    response;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2.1,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    child: CachedNetworkImage(
                     imageUrl: widget.movie.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  )),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15),
                      child: Text(
                        widget.movie.title,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    width: 60,
                    child: BlocConsumer<FavoriteCubit, CommonState>(
                      listener: (context, state) {
                        if (state is CommonSuccessState<bool>) {
                          if (state.item != widget.movie.favorite) {
                            context
                                .read<FetchMovieListBloc>()
                                .add(ReloadMovieEvent());
                            context.read<FetchAllFavoriteCubit>().reload();
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is CommonSuccessState<bool>) {
                          return IconButton(
                            onPressed: () {
                              if (state.item) {
                                context
                                    .read<FavoriteCubit>()
                                    .unfavorite(widget.movie.id as int);
                              } else {
                                context
                                    .read<FavoriteCubit>()
                                    .favorite(widget.movie);
                              }
                            },
                            icon: Icon(
                              state.item
                                  ? Icons.favorite_outlined
                                  : Icons.favorite_outline_outlined,
                              color: Colors.orangeAccent,
                            ),
                          );
                        } else {
                          return const CupertinoActivityIndicator(
                            color: Colors.orangeAccent,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    width: 80,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PlayerScreen(videoId: response)));
                      },
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.orangeAccent,
                        size: 70,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 18),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                      size: 20,
                    ),
                    Text(
                      " Average Rating:${widget.movie.voteAverage}",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              /*    Padding(
                padding: const EdgeInsets.only(top: 14.0, left: 15),
                child: Text(
                  "Description:",
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
                child: Text(
                  widget.movie.overview.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 18, right: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0, top: 5),
                      child: SizedBox(
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:widget.movie.posterImage,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 1),
                          child: Text(
                            "Language: ${widget.movie.originalLanguage}",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 1),
                          child: Text(
                            widget.movie.adult
                                ? "Adult Movie: Yes"
                                : "Adult Movie: No",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 1),
                          child: Text(
                            "Release Date: ${widget.movie.releaseDate}",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.orangeAccent,
                shadows: <Shadow>[
                  Shadow(color: Colors.orangeAccent, blurRadius: 15.0)
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
