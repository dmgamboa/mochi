class ChatMockData {
  static const List<Map<String, dynamic>> users = [
    {
      "uid": "YeF0h3dnBMYQG5nVioRmIExvqTq1",
      "name": "Donna",
      "profile_picture": "https://picsum.photos/200",
      "role": "receiver"
    },
    {
      "uid": "n0MbIAXJ4VRDFf4AwKZJ0bbJa202",
      "name": "Andy",
      "profile_picture": "https://picsum.photos/200",
      "role": "sender"
    },
    {
      "uid": "n0MbIAXJ4VRDFf4AwKZJ0bbJa203",
      "name": "Dustin",
      "profile_picture": "https://picsum.photos/200",
    },
    {
      "uid": "n0MbIAXJ4VRDFf4AwKZJ0bbJa204",
      "name": "Brendan",
      "profile_picture": "https://picsum.photos/200",
    },
    {
      "uid": "n0MbIAXJ4VRDFf4AwKZJ0bbJa204",
      "name": "Vin",
      "profile_picture": "https://picsum.photos/200",
    },
  ];

  static final directMessages = [
    {
      "user_id": "n0MbIAXJ4VRDFf4AwKZJ0bbJa202",
      "message": "hilo",
      "type": "text",
      "date": "2023-03-31T05:55:04.397Z",
      "_id": "642675b80858a8f7af5b121c"
    }
  ];

  static final groupMessages = [
    {
      'sender': users[2],
      'content': 'Hey everyone, how was your weekend?',
      'createdAt': '2022-01-02T09:00:00Z',
      'extension': '',
    },
    {
      'sender': users[0],
      'content': 'It was great! I went to the beach.',
      'createdAt': '2022-01-02T09:05:00Z',
      'extension': '',
    },
    {
      'sender': users[1],
      'content': 'I stayed at home and watched Netflix.',
      'createdAt': '2022-01-02T09:10:00Z',
      'extension': '',
    },
    {
      'id': '7',
      'sender': users[3],
      'content': 'Nice! I went to the beach too!',
      'createdAt': '2022-01-02T09:10:00Z',
      'extension': '',
    },
  ];

  static final chats = [
    {
      "chat": {
        "_id": "642675b80858a8f7af5b121b",
        "participants": [
          "YeF0h3dnBMYQG5nVioRmIExvqTq1",
          "n0MbIAXJ4VRDFf4AwKZJ0bbJa202"
        ],
        "messages": [
          {
            "user_id": "n0MbIAXJ4VRDFf4AwKZJ0bbJa202",
            "message": "hilo",
            "type": "text",
            "date": "2023-03-31T05:55:04.397Z",
            "_id": "642675b80858a8f7af5b121c"
          }
        ],
        "__v": 0
      },
      "participants": [
        {
          "uid": "YeF0h3dnBMYQG5nVioRmIExvqTq1",
          "name": "Donna",
          "profile_picture": "https://picsum.photos/200",
          "role": "receiver"
        },
        {
          "uid": "n0MbIAXJ4VRDFf4AwKZJ0bbJa202",
          "name": "Andy",
          "profile_picture": "https://picsum.photos/200",
          "role": "sender"
        }
      ],
      "last_message": {
        "user_id": "n0MbIAXJ4VRDFf4AwKZJ0bbJa202",
        "message": "hilo",
        "type": "text",
        "date": "2023-03-31T05:55:04.397Z",
        "_id": "642675b80858a8f7af5b121c"
      }
    }
  ];
}
