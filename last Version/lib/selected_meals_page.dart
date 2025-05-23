import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'menucontroller.dart';
import 'mealclass.dart';
import 'model.dart';
import 'user_information.dart';

class SelectedMealsPage extends StatefulWidget {
  const SelectedMealsPage({key});

  @override
  State<SelectedMealsPage> createState() => _SelectedMealsPageState();
}

class _SelectedMealsPageState extends State<SelectedMealsPage> {
  final CustomMenuController controller = Get.find();
  Map<String, TextEditingController> commentControllers = {};
  Map<String, double> ratings = {};
  final SupabaseClient supabase = Supabase.instance.client;

  final List<String> positiveWords = [
    // English
    "good", "great", "amazing", "delicious", "tasty", "excellent", "perfect",
    "yummy", "fantastic", "love", "awesome",
    // Arabic
    "جيد", "رائع", "لذيذ", "ممتاز", "مذهل", "حلو", "جميل", "طعمه حلو", "ممتازة",
    "تحفة", "مميز"
  ];

  final List<String> negativeWords = [
    // English
    "bad", "awful", "terrible", "disgusting", "poor", "hate", "not good",
    "boring", "worst", "ugly", "dry",
    // Arabic
    "سيء", "سئ", "رديء", "وحش", "مقرف", "ما عجبني", "مش حلو", "مش كويس", "ناشف",
    "أسوأ", "مش طيب", "سيئة"
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < controller.meals.length; i++) {
      if (controller.selectedItems[i]) {
        String mealName = controller.meals[i].name;
        commentControllers[mealName] = TextEditingController();
        ratings[mealName] = 0;
      }
    }
  }

  bool hasUnratedMeals() {
    for (var meal in controller.meals) {
      if (controller.selectedItems[controller.meals.indexOf(meal)]) {
        if ((ratings[meal.name] ?? 0) == 0) {
          return true;
        }
      }
    }
    return false;
  }

  bool isFeedbackConsistent(String comment, int rating) {
    final lowerComment = comment.toLowerCase();
    final hasPositive =
        positiveWords.any((word) => lowerComment.contains(word));
    final hasNegative =
        negativeWords.any((word) => lowerComment.contains(word));

    if (rating >= 4 && hasNegative) {
      return false;
    } else if (rating <= 2 && hasPositive) {
      return false;
    }
    return true;
  }

  Future<void> saveFeedback() async {
    List<int> insertedIds = [];

    for (var meal in controller.meals) {
      if (controller.selectedItems[controller.meals.indexOf(meal)]) {
        final name = meal.name;
        final comment = commentControllers[name]?.text ?? '';
        final ratingDouble = ratings[name] ?? 0;
        final rating = ratingDouble.round();

        if (rating > 0 || comment.isNotEmpty) {
          if (!isFeedbackConsistent(comment, rating)) {
            Get.snackbar(
              "Inconsistent Feedback",
              "تقييمك لا يتناسب مع التعليق، يرجى المراجعة.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          final model = Model(
            mealName: name,
            rating: rating,
            feedback: comment,
          );

          try {
            final response = await supabase
                .from('Mero')
                .insert(model.toJson())
                .select()
                .single();

            final insertedId = response['id'];
            insertedIds.add(insertedId);
          } catch (e) {
            print("خطأ أثناء الإدخال إلى Supabase: $e");
            Get.snackbar(
              "Error",
              "حدث خطأ أثناء حفظ التقييم",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      }
    }

    if (insertedIds.isNotEmpty) {
      Get.snackbar(
        "تم الحفظ",
        "تم حفظ تقييماتك بنجاح",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      Get.to(() => UserInfoPage(), arguments: insertedIds);
    } else {
      Get.snackbar(
        "No Feedback",
        "من فضلك أدخل تقييمًا أو تعليقًا أولاً",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = Get.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Your Meals"),
        backgroundColor: const Color(0xFFFFB300),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: controller.meals.length,
                itemBuilder: (context, index) {
                  if (controller.selectedItems[index]) {
                    final meal = controller.meals[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 500 + index * 100),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  meal.image,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                meal.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              RatingBar.builder(
                                initialRating: ratings[meal.name] ?? 0,
                                minRating: 1,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    ratings[meal.name] = rating;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: commentControllers[meal.name],
                                decoration: const InputDecoration(
                                  labelText: "Your feedback",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (hasUnratedMeals()) {
                    Get.snackbar(
                      "مطلوب التقييم",
                      "يرجى تقييم جميع الوجبات المحددة قبل إرسال التعليق",
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  } else {
                    // هنا تظهر رسالة تخبر المستخدم أن البيانات تُخزن
                    Get.snackbar(
                      "جاري الحفظ",
                      "البيانات تُخزن الآن، يرجى الانتظار...",
                      backgroundColor: Colors.blueGrey,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                    saveFeedback();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB300),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Send Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
