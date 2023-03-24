class ChatMockData {
  static const List<Map<String, dynamic>> users = [
    {
      "id": "1",
      "name": "Alice",
      "avatar": "https://picsum.photos/200?seed=1",
    },
    {
      "id": "2",
      "name": "Bob",
      "avatar": "https://picsum.photos/200?seed=2",
    },
    {
      "id": "3",
      "name": "Charlie",
      "avatar": "https://picsum.photos/200?seed=3",
    },
    {
      "id": "4",
      "name": "David",
      "avatar": "https://picsum.photos/200?seed=4",
    },
  ];

  static final directMessages = [
    {
      'id': '1',
      'sender': users[0],
      'content': 'Hey, how are you?',
      'createdAt': '2022-01-01T09:00:00Z',
      'extension': '',
    },
    {
      'id': '2',
      'sender': users[1],
      'content': 'I am doing great! How about you?',
      'createdAt': '2022-01-01T09:05:00Z',
      'extension': '',
    },
    {
      'id': '3',
      'sender': users[0],
      'content': 'I am also doing great! Want to grab some coffee?',
      'createdAt': '2022-01-01T09:10:00Z',
      'extension': '',
    },
  ];

  static final groupMessages = [
    {
      'id': '4',
      'sender': users[2],
      'content': 'Hey everyone, how was your weekend?',
      'createdAt': '2022-01-02T09:00:00Z',
      'extension': '',
    },
    {
      'id': '5',
      'sender': users[0],
      'content': 'It was great! I went to the beach.',
      'createdAt': '2022-01-02T09:05:00Z',
      'extension': '',
    },
    {
      'id': '6',
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
      'id': '1',
      'participants': [users[0], users[1]],
      'lastMessage': directMessages.last,
      'streak': '10'
    },
    {
      'id': '2',
      'participants': [users[0], users[1], users[1], users[2], users[3]],
      'lastMessage': groupMessages.last,
      'streak': '0'
    }
  ];
}
