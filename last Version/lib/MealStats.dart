class MealStats {
  num sum;
  int count;
  List<String> comments;

  MealStats({this.sum = 0, this.count = 0, List<String>? comments})
      : comments = comments ?? [];
}
