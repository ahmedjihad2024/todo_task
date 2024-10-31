

class ArticleRequest{
  final String article;
  int pageSize;
  int pageNumber;
  ArticleRequest({required this.article, required this.pageSize, required this.pageNumber});
}

class LoginRequest{
  final String phone;
  final String password;
  const LoginRequest(
      this.phone,
      this.password
      );
}

class RegisterRequest{
  final String userName;
  final String password;
  final String phone;
  final int experienceYears;
  final String address;
  final String level;
  const RegisterRequest(
      this.userName,
      this.address,
      this.password,
      this.experienceYears,
      this.level,
  this.phone
      );
}