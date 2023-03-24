import 'package:flutter/material.dart';
import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/contacts/domain/models/models.dart';

class SearchFriendsResult extends StatefulWidget {
  final SearchResult result;
  final Function(User) onAddFriend;

  const SearchFriendsResult({
    required this.result,
    required this.onAddFriend,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchFriendsResult> createState() => _SearchFriendsResultState();
}

class _SearchFriendsResultState extends State<SearchFriendsResult> {
  bool sentRequest = false;

  @override
  void initState() {
    super.initState();
    sentRequest = widget.result.status == FriendStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              widget.result.user.avatar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.result.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (widget.result.user.statusMessage != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      widget.result.user.statusMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          if (widget.result.status != FriendStatus.friend)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: !sentRequest
                  ? () {
                      widget.onAddFriend(widget.result.user);
                      setState(() => sentRequest = true);
                    }
                  : null,
              child: Text(
                !sentRequest ? 'Add Friend' : 'Pending',
              ),
            )
        ],
      ),
    );
  }
}
