class UserData {
  final String _uid;
  final String _email;
  bool _isAdmin;
  UserData(this._uid, this._email);

  bool get isAdmin => _isAdmin;

  set isAdmin(bool value) {
    _isAdmin = value;
  }

  String get email => _email;

  String get uid => _uid;


}