// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/constants/constants.dart';

getTrailer(id) async {
  var client = http.Client();

  var url = "${Constants.baseUrl}/3/movie/$id/videos?language=en-US";
  final uri = Uri.parse(url);
  final response = await client.get(uri, headers: {
    'authorization':
        "bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYWUyMzRlZjhiZjQzNTVlODQzYTAwMzNhMDJiOGY4MCIsInN1YiI6IjY0ZGUyZjUwYTNiNWU2MDBjNWJjOTU5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GYA6zDpO4S1GL47-HQJs1t2e1cpv8-MWxw70wd_x_EY"
  });

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final site = json['results'][0]['site'];

    if (site == "YouTube") {
      var ytVideoId = json['results'][0]['key'];
      return ytVideoId;
    } else {
      var ytVideoId = json['results'][1]['key'];
      return ytVideoId;
    }
  } else {
    throw "Something went wrong code ${response.statusCode}";
  }
}
