import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'mealclass.dart';

// الكنترولر
class CustomMenuController extends GetxController {
  // تعريف meals كـ List من الكائنات Meal
  final meals = [
    // Meal(name: 'Burger', image: 'assets/burger.jpg'),
    Meal(name: 'Shrimp Pasta', image: 'assets/chremppasta.jpg'),
    Meal(name: 'Corn dog', image: 'assets/corndog.jpg'),
    Meal(name: 'Fried Chicken', image: 'assets/fried_chiken.jpg'),
    Meal(name: 'Fries', image: 'assets/fries.jpg'),
    Meal(name: 'Indomie', image: 'assets/indomiee.jpg'),
    Meal(name: 'Pizza', image: 'assets/pizza (2).jpg'),
    Meal(name: 'Mozzarella', image: 'assets/mutzarilla.jpg'),
    Meal(name: 'Pasta', image: 'assets/pasta.jpg'),
    Meal(name: 'Takos', image: 'assets/takoo.jpg'),
  ];

  var selectedItems = List<bool>.filled(10, false).obs;

  void updateSelection(int index, bool value) {
    selectedItems[index] = value;
  }

  void resetSelections() {
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = false;
    }
  }
}
