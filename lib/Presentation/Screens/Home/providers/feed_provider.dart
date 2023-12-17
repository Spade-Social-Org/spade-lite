import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Common/api_handler/api_client_config.dart';
import 'package:spade_lite/Common/api_handler/api_handler_models.dart';
import 'package:spade_lite/Common/utils/string_exception.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_snackbar.dart';
import 'package:spade_lite/prefs/local_data.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

final feedProvider = StateNotifierProvider<FeedProvider, FeedRepo>((ref) {
  return FeedProvider(ref);
});

final storyProvider = StateProvider<FeedModel?>((ref) {
  final stories = ref.watch(feedProvider).storyModel;
  final user = ref.watch(userIdProvider);
  if (stories == null) return null;
  final newStories = groupBy<Feed, String>(
          stories.data ?? [], (p0) => '${p0.posterId}')
      .map(
        (key, value) => MapEntry(
          key,
          value.fold(
            Feed(
              posterName: value.first.posterName,
              posterImage: value.first.posterImage,
              createdAt: value.first.createdAt,
              posterId: value.first.posterId,
              bookmarked: value.first.bookmarked,
              description: value.first.description,
              id: value.first.id,
              likedPost: value.first.likedPost,
              gallery: {},
              numberOfLikes: value.first.numberOfLikes,
            ),
            (value, element) => value.copyWith(
              gallery: {
                ...value.gallery ?? [],
                ...element.gallery ?? [],
              },
            ),
          ),
        ),
      )
      .values
      .where((element) => element.posterId != int.tryParse(user.value ?? ''))
      .toList();
  final new2 = [
    ...newStories.where((element) =>
        element.gallery?.any(
            (element) => LocalData.instance.isStoryViewed(element) == false) ??
        true),
    ...newStories.where((element) =>
        element.gallery?.any(
            (element) => LocalData.instance.isStoryViewed(element) == true) ??
        false),
  ];
  return stories.copyWith(
    data: new2,
  );
});

final userStoryProvider = StateProvider<List<Feed>?>((ref) {
  final stories = ref.watch(feedProvider).storyModel;
  final user = ref.watch(userIdProvider);
  if (stories == null) return null;
  final newStories = stories.data
      ?.where((element) => element.posterId == int.tryParse(user.value ?? ''))
      .toList();
  return newStories;
});

class FeedProvider extends StateNotifier<FeedRepo> {
  final Ref ref;

  FeedProvider(this.ref) : super(FeedRepo()) {
    fetchPosts();
    fetchStories();
  }

  Future<bool> bookmarkPost({
    required bool action,
    required int id,
    bool isStory = false,
  }) async {
    final res = await state.bookmarkPost(
      action: action,
      id: id,
    );

    if (res.valid) {
      (isStory ? state.storyModel : state.feedModel)
          ?.data
          ?.firstWhereOrNull(
            (element) => element.id == id,
          )!
          .bookmarked = action ? 'true' : 'false';
      return action;
    } else {
      return !action;
    }
  }

  Future<void> onCancelCreatePost() async {
    state = state
      ..onRetryPost = null
      ..filePath = null
      ..uploadProgress = null;
    state = state.copyWith();
  }

  Future<void> createPost(
    BuildContext context, {
    required bool isStory,
    required List<String> filePath,
    String? description,
    bool isVideo = false,
  }) async {
    state = state..onRetryPost = null;
    state = state.copyWith(
      filePath: filePath.first,
      uploadProgress: 0,
    );

    final res = await state.createPost(
      description: description,
      filePath: filePath,
      isStory: isStory,
      isVideo: isVideo,
      onProgress: (double progress) {
        state = state.copyWith(
          uploadProgress: progress,
        );
      },
    );

    if (res.valid) {
      state = state
        ..uploadProgress = null
        ..onRetryPost = null
        ..filePath = null;
      state = state.copyWith();
      fetchPosts(refreshToNew: true);
      fetchStories(refreshToNew: true);
    } else {
      state = state
        ..onRetryPost = () {
          createPost(
            context,
            isStory: isStory,
            filePath: filePath,
            description: description,
          );
        };

      state = state.copyWith();
      customSnackBar(res.error!.message!);
      //throw StringException(res.error!.message!);
    }
  }

  Future<void> fetchPosts({
    bool refreshToNew = true,
  }) async {
    state = state.copyWith(
      feedLoading: true,
    );

    final res = await state.getFeed(
      url: refreshToNew ? null : state.feedModel?.meta?.next,
    );

    state = state.copyWith(
      feedLoading: false,
    );

    if (!res.valid) {
      throw StringException(res.error!.message!);
    }

    if (refreshToNew) {
      state = state.copyWith(
        feedModel: res.data,
      );
    } else {
      state = state.copyWith(
        feedModel: res.data!.copyWith(
          data: [
            ...state.feedModel!.data!,
            ...res.data!.data!,
          ],
        ),
      );
    }
  }

  Future<void> fetchStories({
    bool refreshToNew = true,
  }) async {
    state = state.copyWith(
      storyLoading: true,
    );

    final res = await state.getFeed(
      url: refreshToNew ? null : state.storyModel?.meta?.next,
      isStory: true,
    );

    state = state.copyWith(
      storyLoading: false,
    );

    if (!res.valid) {
      throw StringException(res.error!.message!);
    }

    if (refreshToNew) {
      state = state.copyWith(
        storyModel: res.data,
      );
    } else {
      state = state.copyWith(
        storyModel: res.data!.copyWith(
          data: [
            ...state.storyModel!.data!,
            ...res.data!.data!,
          ],
        ),
      );
    }
  }

  Future<bool> likePost({
    required bool action,
    required int id,
    required bool isStory,
  }) async {
    final res = await state.likePost(
      action: action,
      id: id,
    );

    if (res.valid) {
      (isStory ? state.storyModel : state.feedModel)
          ?.data
          ?.firstWhereOrNull(
            (element) => element.id == id,
          )!
          .likedPost = action ? 'true' : 'false';
      return action;
    } else {
      return !action;
    }
  }
}

class FeedRepo {
  static final PageController pageController = PageController(initialPage: 1);
  FeedModel? storyModel;
  bool storyLoading;
  FeedModel? feedModel;
  bool feedLoading;
  String? filePath;
  double? uploadProgress;
  void Function()? onRetryPost;

  final BackendService _apiService = BackendService(
    Dio(),
  );

  FeedRepo({
    this.storyModel,
    this.storyLoading = false,
    this.feedModel,
    this.feedLoading = false,
    this.filePath,
    this.onRetryPost,
    this.uploadProgress,
  });

  Future<ResponseModel> bookmarkPost({
    required bool action,
    required int id,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.patch(
        '${AppEndpoints.baseUrl}/api/v1/posts/bookmark/$id/${action ? 'save' : 'remove'}',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: response.data,
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  FeedRepo copyWith({
    FeedModel? storyModel,
    bool? storyLoading,
    FeedModel? feedModel,
    bool? feedLoading,
    String? filePath,
    double? uploadProgress,
    void Function()? onRetryPost,
  }) {
    return FeedRepo(
      storyModel: storyModel ?? this.storyModel,
      storyLoading: storyLoading ?? this.storyLoading,
      feedModel: feedModel ?? this.feedModel,
      feedLoading: feedLoading ?? this.feedLoading,
      filePath: filePath ?? this.filePath,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      onRetryPost: onRetryPost ?? this.onRetryPost,
    );
  }

  Future<ResponseModel> createPost({
    required bool isStory,
    required List<String> filePath,
    bool isVideo = false,
    required Function(double) onProgress,
    String? description,
  }) async {
    final data = FormData.fromMap({
      if (description != null) "description": description,
      "is_story": isStory,
    });
    for (var i in filePath) {
      final file = await MultipartFile.fromFile(
        i,
        filename: i.split('/').last,
        contentType:
            isVideo ? MediaType('video', 'mp4') : MediaType('image', 'jpg'),
      );
      data.files.add(
        MapEntry('files', file),
      );
    }

    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/v1/posts',
        data: data,
        onSendProgress: (int sent, int total) {
          onProgress(sent / total);
        },
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: response.data,
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<FeedModel>> getFeed({
    String? url,
    bool isStory = false,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.get(
        url ?? '${AppEndpoints.baseUrl}/api/v1/posts/user/feeds',
        queryParameters: {
          'is_story': isStory,
        },
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: FeedModel.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel> likePost({
    required bool action,
    required int id,
  }) async {
    Response response = await _apiService.runCall(
      _apiService.dio.patch(
        '${AppEndpoints.baseUrl}/api/v1/posts/like/$id/${action ? 'like' : 'unlike'}',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: response.data,
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }
}
