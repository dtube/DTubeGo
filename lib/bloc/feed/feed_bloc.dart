import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/feed/feed_state.dart';
import 'package:dtube_go/bloc/feed/feed_event.dart';
import 'package:dtube_go/bloc/feed/feed_response_model.dart';
import 'package:dtube_go/bloc/feed/feed_repository.dart';
import 'package:dtube_go/res/Config/ExploreConfigValues.dart';
import 'package:dtube_go/res/Config/appConfigValues.dart';
import 'package:dtube_go/utils/GlobalStorage/SecureStorage.dart' as sec;

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedRepository repository;
  bool isFetching = false;

  FeedBloc({required this.repository}) : super(FeedInitialState()) {
    on<InitFeedEvent>((event, emit) async {
      emit(FeedInitialState());
    });

    on<FetchMomentsEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      String _tsRangeFilter = '&tsrange=' +
          (DateTime.now()
                      .add(Duration(days: AppConfig.momentsPastXDays))
                      .millisecondsSinceEpoch /
                  1000)
              .toString() +
          ',' +
          (DateTime.now().millisecondsSinceEpoch / 1000).toString();

      emit(FeedLoadingState());
      try {
        List<FeedItem> feed = event.feedType == "NewMoments"
            ? await repository.getNewFeedFiltered(
                _avalonApiNode,
                "&authors=all,%5Es3rk47" +
                    _blockedUsersFilter +
                    "&tags=DTubeGo-Moments",
                _tsRangeFilter,
                _applicationUser)
            : await repository.getMyFeedFiltered(_avalonApiNode,
                "&tags=DTubeGo-Moments", _tsRangeFilter, _applicationUser);

        // remove already seen moments
        //uncomment this to see aso seen moments

        List<FeedItem> feedCopy = List.from(feed);
        for (var f in feedCopy) {
          bool momentAlreadySeen =
              await sec.getSeenMomentAlready(f.author + "/" + f.link);
          if (momentAlreadySeen) {
            feed.remove(f);
          }
        }
        // reverse feed to have the moments in ascending order
        List<FeedItem> feedReversed = new List.from(feed.reversed);
        emit(FeedLoadedState(feed: feedReversed, feedType: event.feedType));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchMomentsOfUserEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      String _tsRangeFilter = '&tsrange=' +
          (DateTime.now()
                      .add(Duration(
                          days: ExploreConfig.maxDaysInPastForSuggestions * -1))
                      .millisecondsSinceEpoch /
                  1000)
              .toString() +
          ',' +
          (DateTime.now().millisecondsSinceEpoch / 1000).toString();

      emit(FeedLoadingState());
      try {
        List<FeedItem> feed = event.feedType == "NewUserMoments"
            ? await repository.getNewFeedFiltered(
                _avalonApiNode,
                "&authors=" + event.username + "&tags=DTubeGo-Moments",
                _tsRangeFilter,
                _applicationUser)
            : await repository.getMyFeedFiltered(_avalonApiNode,
                "&tags=DTubeGo-Moments", _tsRangeFilter, _applicationUser);
        emit(FeedLoadedState(feed: feed, feedType: event.feedType));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchTagSearchResults>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      String _tsRangeFilter = '&tsrange=' +
          (DateTime.now()
                      .add(Duration(
                          days: ExploreConfig.maxDaysInPastForSuggestions * -1))
                      .millisecondsSinceEpoch /
                  1000)
              .toString() +
          ',' +
          (DateTime.now().millisecondsSinceEpoch / 1000).toString();

      emit(FeedLoadingState());
      try {
        List<FeedItem> feed = await repository.getNewFeedFiltered(
            _avalonApiNode,
            (event.tags != "all" ? "&tags=" + event.tags : "") +
                "&authors=all,%5Es3rk47" +
                _blockedUsersFilter,
            _tsRangeFilter,
            _applicationUser);
        emit(FeedLoadedState(feed: feed, feedType: "tagSearch"));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchFeedEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      print("FETCH " + event.feedType);
      emit(FeedLoadingState());
      try {
        List<FeedItem> feed = [];
        switch (event.feedType) {
          case 'MyFeed':
            {
              feed = await repository.getMyFeed(
                  _avalonApiNode,
                  _applicationUser,
                  event.fromAuthor,
                  event.fromLink,
                  _blockedUsers);
            }
            break;
          case 'HotFeed':
            {
              feed = await repository.getHotFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser,
                  _blockedUsers);
            }
            break;
          case 'TrendingFeed':
            {
              feed = await repository.getTrendingFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser,
                  _blockedUsers);
            }
            break;
          case 'NewFeed':
            {
              feed = await repository.getNewFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser,
                  _blockedUsers);
            }
            break;
          case 'ODFeed':
            {
              feed = await repository.getODFeed(
                  _avalonApiNode,
                  event.fromAuthor,
                  event.fromLink,
                  _applicationUser,
                  _blockedUsers);
            }
            break;
          case 'NewsFeed':
            {
              String? _TSFrom = await sec.getUsername();
              String? _TSTo = await sec.getUsername();
              feed = await repository.getNewsFeed(
                _avalonApiNode,
                _applicationUser,
              );
            }
            break;
        }

        emit(FeedLoadedState(feed: feed, feedType: event.feedType));
      } catch (e) {
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchUserFeedEvent>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      emit(FeedLoadingState());
      try {
        List<FeedItem> feed = await repository.getNewFeedFiltered(
            _avalonApiNode,
            "&authors=" + event.username + "&tags=all,%5EDTubeGo-Moments",
            "" // tsrange currently not used here to load all uploads of the user
            ,
            _applicationUser);
        emit(FeedLoadedState(feed: feed, feedType: "UserFeed"));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchSuggestedUsersForUserHistory>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      emit(SuggestedUsersLoadingState());

      try {
        String _tsRangeFilterUser = '&tsrange=' +
            (DateTime.now()
                        .add(Duration(
                            days:
                                ExploreConfig.maxDaysInPastForSuggestions * -1))
                        .millisecondsSinceEpoch /
                    1000)
                .toString() +
            ',' +
            (DateTime.now().millisecondsSinceEpoch / 1000).toString();
        // get recent posts of the user
        List<FeedItem> _feed = await repository.getNewFeedFiltered(
            _avalonApiNode,
            "&authors=" + event.username + "&tags=all,%5EDTubeGo-Moments",
            _tsRangeFilterUser,
            _applicationUser);

        // build list of tags for videos of the user

        List<String> _tags = [];
        for (var post in _feed) {
          for (var tag in post.tags) {
            if (!_tags.contains(tag) &&
                // Exclude generic curation tags from suggested search
                !ExploreConfig.genericCurationTags.contains(tag)) {
              _tags.add(tag);
            }
          }
        }
        List<String> _suggestedUsers = [];

        //query posts with those tags

        if (_tags.length > 0) {
          Map<String, int> _usersPostCount = {};
          String _tsRangeFilterOtherUsers = '&tsrange=' +
              (DateTime.now()
                          .add(Duration(
                              days: ExploreConfig.maxDaysInPastForSuggestions *
                                  -1))
                          .millisecondsSinceEpoch /
                      1000)
                  .toString() +
              ',' +
              (DateTime.now().millisecondsSinceEpoch / 1000).toString();

          List<FeedItem> _otherUsersFeed = await repository.getNewFeedFiltered(
              _avalonApiNode,
              "&authors=all,%5E" +
                  event.username + // not from the same user
                  _blockedUsersFilter + // not from blocked users
                  "&tags=" +
                  _tags.join(',') + // with tags of the users videos
                  ",%5EDTubeGo-Moments",
              _tsRangeFilterOtherUsers, // only last x days
              _applicationUser);

          // count count of posts per user

          if (_otherUsersFeed.length > 0) {
            for (var post in _otherUsersFeed) {
              if (_usersPostCount[post.author] == null) {
                _usersPostCount[post.author] = 1;
              } else {
                _usersPostCount[post.author] =
                    _usersPostCount[post.author]! + 1;
              }
            }
            // sort counted list by count

            var _sortedByValue = new SplayTreeMap.from(
                _usersPostCount,
                (key2, key1) =>
                    _usersPostCount[key1]!.compareTo(_usersPostCount[key2]!));
            // add sorted users to list
            print("// add sorted users to list");
            _sortedByValue.forEach((key, value) {
              _suggestedUsers.add(key.toString());
            });
          }
        }

        emit(SuggestedUsersLoadedState(
            users: _suggestedUsers
                .take(ExploreConfig.maxUserSuggestions)
                .toList()));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchSuggestedUsersForPost>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      emit(SuggestedUsersLoadingState());

      try {
        List<String> _suggestedUsers = [];

        //query posts with the tags
        if (event.tags.length > 0) {
          Map<String, int> _usersPostCount = {};
          String _tsRangeFilterOtherUsers = '&tsrange=' +
              (DateTime.now()
                          .add(Duration(
                              days: ExploreConfig.maxDaysInPastForSuggestions *
                                  -1))
                          .millisecondsSinceEpoch /
                      1000)
                  .toString() +
              ',' +
              (DateTime.now().millisecondsSinceEpoch / 1000).toString();

          List<FeedItem> _otherUsersFeed = await repository.getNewFeedFiltered(
              _avalonApiNode,
              "&authors=all,%5E" +
                  event.currentUsername + // not from the same user
                  _blockedUsersFilter // not from blocked users
                  +
                  "&tags=" +
                  event.tags.join(',') + // with tags of the users video
                  ",%5EDTubeGo-Moments",
              _tsRangeFilterOtherUsers, // only last x days
              _applicationUser);

          // count count of posts per user

          if (_otherUsersFeed.length > 0) {
            for (var post in _otherUsersFeed) {
              if (_usersPostCount[post.author] == null) {
                _usersPostCount[post.author] = 1;
              } else {
                _usersPostCount[post.author] =
                    _usersPostCount[post.author]! + 1;
              }
            }
            // sort counted list by count
            print("// sort counted list by count");
            var _sortedByValue = new SplayTreeMap.from(
                _usersPostCount,
                (key2, key1) =>
                    _usersPostCount[key1]!.compareTo(_usersPostCount[key2]!));
            // add sorted users to list
            print("// add sorted users to list");
            _sortedByValue.forEach((key, value) {
              _suggestedUsers.add(key.toString());
            });
          }
        }

        emit(SuggestedUsersLoadedState(
            users: _suggestedUsers
                .take(ExploreConfig.maxUserSuggestions)
                .toList()));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });

    on<FetchSuggestedPostsForPost>((event, emit) async {
      String _avalonApiNode = await sec.getNode();
      String? _applicationUser = await sec.getUsername();

      // read and prepare the blocked list for the search filters
      String? _blockedUsers = await sec.getBlockedUsers();
      String _blockedUsersFilter = "";
      if (_blockedUsers != "") {
        for (var u in _blockedUsers.split(",")) {
          _blockedUsersFilter = ",%5E" + u;
        }
      }
      emit(FeedLoadingState());

      try {
        List<FeedItem> _suggestedPosts = [];

        String _tsRangeFilterOtherUsers = '&tsrange=' +
            (DateTime.now()
                        .add(Duration(
                            days:
                                ExploreConfig.maxDaysInPastForSuggestions * -1))
                        .millisecondsSinceEpoch /
                    1000)
                .toString() +
            ',' +
            (DateTime.now().millisecondsSinceEpoch / 1000).toString();

        List<FeedItem> _otherUsersFeed = await repository.getNewFeedFiltered(
            _avalonApiNode,
            "&authors=all,%5E" +
                event.currentUsername + // not from the same user
                _blockedUsersFilter + // not from blocked users
                "&tags=" +
                event.tags.join(',') + // with tags of the users video
                ",%5EDTubeGo-Moments",
            _tsRangeFilterOtherUsers, // only last x days
            _applicationUser);
        emit(FeedLoadedState(
            feed:
                _otherUsersFeed.take(ExploreConfig.maxUserSuggestions).toList(),
            feedType: "SuggestedPosts"));
      } catch (e) {
        print(e.toString());
        emit(FeedErrorState(message: e.toString()));
      }
    });
  }
}
