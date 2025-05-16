import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mealclass.dart';
import 'menucontroller.dart';
import 'selected_meals_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({key});

  @override
  Widget build(BuildContext context) {
    final CustomMenuController controller = Get.put(CustomMenuController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Meals"),
        backgroundColor: Color(0xFFFFB300),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12.0),
                itemCount: controller.meals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var meal = controller.meals[index];
                  return Obx(
                    () => Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  meal.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          value: controller.selectedItems[index],
                          onChanged: (bool? value) {
                            controller.updateSelection(index, value!);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final selectedNames = controller.meals
                      .asMap()
                      .entries
                      .where((entry) => controller.selectedItems[entry.key])
                      .map((entry) => entry.value.name)
                      .toList();

                  if (selectedNames.isEmpty) {
                    Get.snackbar(
                      "لم يتم اختيار وجبات",
                      "يرجى اختيار وجبة واحدة على الأقل للمتابعة",
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.to(() => SelectedMealsPage(), arguments: selectedNames);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB300),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
