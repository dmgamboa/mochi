import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/contacts/domain/models/models.dart';

class SearchResult {
  final User user;
  final FriendStatus status;

  SearchResult({
    required this.user,
    required this.status,
  });
}
