import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterglobal/Models/anime_episode.dart';
import 'package:flutterglobal/View/WatchAnimeDetails/cubit/watch_anime_details_state.dart';

class WatchAnimeDetailsCubit extends Cubit<WatchAnimeDetailsState> {
  AnimeEpisode animeEpisode;
  InAppWebViewController? webViewController;
  WatchAnimeDetailsCubit({required this.animeEpisode})
      : super(WatchAnimeDetailsState(
            animeEpisode: animeEpisode,
            selectedOption: animeEpisode.links?.first));

  void setSelectedOption(Links? value) {
    if (value == null) return;
    emit(state.copyWith(selectedOption: value));
    webViewController?.loadUrl(
        urlRequest: URLRequest(url: Uri.parse(value.url!)));
  }

  void setIsVideoLoading(bool value) {
    emit(state.copyWith(isVideoLoading: value));
  }
}