import 'package:mochi/core/models/models.dart';
import '../data/respository/repository.dart';
import '../data/datasources/datasources.dart';
import '../domain/models/models.dart';

class FriendsService {
  late final FriendsRemoteDataSource source;

  FriendsService() {
    source = FriendsRemoteDataSource();
  }

  Future<List<User>> getFriends() async {
    final res = await source.getFriends();
    return FriendsListRepository.fromServer(res);
  }

  Future<List<FriendRequest>> getIncomingRequests() async {
    final res = await source.getIncomingRequests();
    return FriendRequestsRepository.fromServer(res);
  }

  // Future<List<FriendRequest>> getOutgoingRequests() async {
  //   final res = await source.getOutgoingRequests();
  //   return FriendRequestsRepository.fromServer(res);
  // }

  Future<List<SearchResult>> searchUsers(String query) async {
    final res = await source.searchUsers(query);
    return SearchResultsRepository.fromServer(res);
  }

  // Future<List<FriendRequest>> handleFriendRequest(
  //   String userId,
  //   bool accept,
  // ) async {
  //   final res = await source.handleFriendRequest(userId, accept);
  //   return FriendRequestsRepository.fromServer(res);
  // }

  // Future<List<FriendRequest>> cancelFriendRequest(String userId) async {
  //   final res = await source.cancelFriendRequest(userId);
  //   return FriendRequestsRepository.fromServer(res);
  // }

  Future<String> sendFriendRequest(String userId) async {
    final res = await source.sendFriendRequest(userId);
    return res;
  }
}
