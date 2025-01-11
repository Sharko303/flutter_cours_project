import 'package:flutter/material.dart';

class Follow with ChangeNotifier {
  bool _isFollowed = false;

  bool get isFollowed => _isFollowed;

  void follow() {
    _isFollowed = true;
    notifyListeners();
  }

  void unfollow() {
    _isFollowed = false;
    notifyListeners();
  }
}