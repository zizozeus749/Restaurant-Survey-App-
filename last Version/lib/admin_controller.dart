import 'package:get/get.dart';
import 'MealRating.dart';
import 'MealStats.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminController extends GetxController {
  var allMeals = <MealRating>[].obs;
  var filteredMeals = <MealRating>[].obs;
  var isLoading = true.obs;

  void fetchData() async {
    try {
      isLoading.value = true;

      final responseRaw = await Supabase.instance.client.from('Mero').select();
      final List<Map<String, dynamic>> response =
          List<Map<String, dynamic>>.from(responseRaw);

      if (response.isEmpty) {
        isLoading.value = false;
        return;
      }

      Map<String, MealStats> mealData = {};

      for (var row in response) {
        final name = row['meal_name'] as String;
        final rating = row['rating'] as num?;
        final comment = row['feedback'] as String?;

        mealData.putIfAbsent(name, () => MealStats());
        final current = mealData[name]!;

        current.sum += rating ?? 0;
        current.count += 1;
        if (comment != null) {
          current.comments.add(comment);
        }
      }

      List<MealRating> meals = mealData.entries.map((e) {
        final avg = e.value.sum / e.value.count;
        return MealRating(
          name: e.key,
          averageRating: avg.toDouble(),
          comments: List<String>.from(e.value.comments),
        );
      }).toList();

      allMeals.assignAll(meals);
      filteredMeals.assignAll(meals);
      isLoading.value = false;
    } catch (e) {
      print('Error: $e');
      isLoading.value = false;
    }
  }

  void filterMeals(String type) {
    if (type == 'Best') {
      filteredMeals.assignAll(allMeals.where((m) => m.averageRating >= 4));
    } else if (type == 'Worst') {
      filteredMeals.assignAll(allMeals.where((m) => m.averageRating < 2));
    } else if (type == 'Average') {
      filteredMeals.assignAll(
          allMeals.where((m) => m.averageRating >= 2 && m.averageRating < 4));
    } else {
      filteredMeals.assignAll(allMeals);
    }
  }
}
