class User {
  final int id;
  var wishList = [];
  final String email, username;

  User({
    this.id,
    this.wishList,
    this.email,
    this.username,
  });
}

// Our demo Products

List<int> wishList = [];

List<User> demoUser = [
  User(
    id: 1,
    wishList: [
      1,
      2,
      3
    ],
    email: "test@gmail.com",
    username: "test",
  ),
];
