import 'package:flutter/material.dart';

import 'package:mochi/core/models/models.dart';
import '../../domain/models/friend_request.dart';

class OutgoingRequests extends StatelessWidget {
  final List<FriendRequest> requests;
  final Function(User) onCancel;

  const OutgoingRequests({
    required this.requests,
    required this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? const Center(child: Text('No requests'))
        : ListView.builder(
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              final request = requests[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        request.user.avatar,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => onCancel(request.user),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text('Cancel'),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }
}
