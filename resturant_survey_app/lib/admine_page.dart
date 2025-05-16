import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:readmore/readmore.dart';

class MealRating {
  final String name;
  final double averageRating;
  final List<String> comments;

  MealRating({
    required this.name,
    required this.averageRating,
    required this.comments,
  });
}

class AdminePage extends StatefulWidget {
  const AdminePage({Key? key}) : super(key: key);

  @override
  State<AdminePage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<MealRating> allMeals = [];
  List<MealRating> filteredMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final List<dynamic> response =
          await supabase.from('Mero').select() as List<dynamic>;

      if (response.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      Map<String, Map<String, dynamic>> mealData = {};
      for (var row in response) {
        final name = row['meal_name'] as String;
        final rating = row['rating'] as num?;
        final comment = row['feedback'] as String?;

        if (!mealData.containsKey(name)) {
          mealData[name] = {
            'sum': rating ?? 0,
            'count': 1,
            'comments': comment != null ? [comment] : [],
          };
        } else {
          mealData[name]!['sum'] =
              (mealData[name]!['sum'] as num) + (rating ?? 0);
          mealData[name]!['count'] = (mealData[name]!['count'] as int) + 1;
          if (comment != null) {
            (mealData[name]!['comments'] as List).add(comment);
          }
        }
      }

      List<MealRating> meals = mealData.entries.map((e) {
        final avg = (e.value['sum'] as num) / (e.value['count'] as int);
        final comms = List<String>.from(e.value['comments'] as List);
        return MealRating(
          name: e.key,
          averageRating: avg.toDouble(),
          comments: comms,
        );
      }).toList();

      setState(() {
        allMeals = meals;
        filteredMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void filterMeals(String filterType) {
    List<MealRating> filteredList;
    if (filterType == 'Best') {
      filteredList = allMeals.where((meal) => meal.averageRating >= 4).toList();
    } else if (filterType == 'Worst') {
      filteredList = allMeals.where((meal) => meal.averageRating < 2).toList();
    } else if (filterType == 'All') {
      filteredList = allMeals;
    } else {
      filteredList = allMeals
          .where((meal) => meal.averageRating >= 2 && meal.averageRating < 4)
          .toList();
    }

    setState(() {
      filteredMeals = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0), // برتقالي فاتح (لون الخلفية الأصلي)
              Color(0xFFFFB300), // أصفر برتقالي (لون الخلفية الأصلي)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "📊 Admin Dashboard",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFilterButton('أفضل الوجبات', 'Best'),
                          _buildFilterButton('أضعف الوجبات', 'Worst'),
                          _buildFilterButton('المتوسطة', 'Average'),
                          _buildFilterButton('الكل', 'All'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: filteredMeals.length,
                        itemBuilder: (context, index) {
                          final meal = filteredMeals[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '📈 Average Rating: ${meal.averageRating.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '💬 Comments:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ...meal.comments.map(
                                    (c) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: ReadMoreText(
                                        '• $c',
                                        trimLines: 2,
                                        colorClickableText: Colors.orange,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...قراءة المزيد',
                                        trimExpandedText: ' عرض أقل',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        moreStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFB300),
                                        ),
                                        lessStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String type) {
    return ElevatedButton(
      onPressed: () => filterMeals(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFFFB300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
