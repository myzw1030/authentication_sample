String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

String? validateConfirmPassword(String? value, text) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  // パスワードとテキストフィールドの内容と照合
  if (value != text) {
    return 'Password does not match';
  }
  return null;
}
