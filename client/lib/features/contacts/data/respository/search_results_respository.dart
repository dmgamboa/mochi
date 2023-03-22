import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/contacts/domain/models/models.dart';
import 'package:collection/collection.dart';

class SearchResultsRepository {
  static List<SearchResult> fromMockData(List<Map<String, dynamic>> results) {
    return results.map((e) => fromJSON(e)).toList();
  }

  static SearchResult fromJSON(Map<String, dynamic> json) {
    return SearchResult(
      user: User.fromJson(json['user']),
      status: FriendStatus.values
              .firstWhereOrNull((e) => e.name == json['status']) ??
          FriendStatus.notFriend,
    );
  }

  static List<SearchResult> fromServer(List<Map<String, dynamic>> results) {
    return results.map((e) => fromJSON(e)).toList();
  }
}
