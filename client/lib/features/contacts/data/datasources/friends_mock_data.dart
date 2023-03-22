class FriendsMockData {
  static const List<Map<String, dynamic>> friends = [
    {
      "id": "1",
      "name": "Alice",
      "avatar": "https://picsum.photos/200?seed=1",
      "statusMessage": "Nice to meet you!"
    },
    {
      "id": "2",
      "name": "Bob",
      "avatar": "https://picsum.photos/200?seed=2",
      "statusMessage": "ASL? :P"
    },
    {
      "id": "3",
      "name": "Charlie",
      "avatar": "https://picsum.photos/200?seed=3",
      "statusMessage": "This app is so cool wooooooooooow."
    },
    {
      "id": "4",
      "name": "David",
      "avatar": "https://picsum.photos/200?seed=4",
      "statusMessage": ""
    },
  ];

  static List<Map<String, dynamic>> incomingRequests = [
    {
      "user": friends[0],
      "dateSent": "2021-05-01T00:00:00.000Z",
    },
    {
      "user": friends[1],
      "dateSent": "2021-02-01T00:00:00.000Z",
    }
  ];

  static List<Map<String, dynamic>> outgoingRequests = [
    {
      "user": friends[2],
      "dateSent": "2021-07-01T00:00:00.000Z",
    },
    {
      "user": friends[3],
      "dateSent": "2021-01-01T00:00:00.000Z",
    }
  ];

  static List<Map<String, dynamic>> searchResults = [
    {
      "user": friends[0],
      "status": "friend",
    },
    {
      "user": friends[1],
      "status": "pending",
    },
    {
      "user": friends[2],
      "status": "notFriend",
    },
    {
      "user": friends[3],
      "status": "pending",
    },
  ];
}
