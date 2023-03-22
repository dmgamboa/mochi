import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/contacts/domain/models/models.dart';
import 'package:mochi/features/contacts/presentation/widgets/widgets.dart';

class AddFriend extends StatefulWidget {
  final List<SearchResult> searchResults;
  final Function(String) onSearch;
  final Function(User) onSendRequest;

  const AddFriend({
    required this.searchResults,
    required this.onSearch,
    required this.onSendRequest,
    Key? key,
  }) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: (value) => widget.onSearch(textController.text),
                decoration: const InputDecoration(
                  hintText: 'Enter Display Name or Email',
                  prefixIcon: Icon(CupertinoIcons.search),
                  contentPadding: EdgeInsets.only(left: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    gapPadding: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => textController.clear(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              child: const Icon(CupertinoIcons.restart),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
              children: widget.searchResults
                  .map((e) => SearchFriendsResult(
                        result: e,
                        onAddFriend: widget.onSendRequest,
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
