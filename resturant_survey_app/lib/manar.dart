import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as cloud;
import 'main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'model.dart';

class Manar extends StatefulWidget {
  const Manar({super.key});

  @override
  State<Manar> createState() => _ManarState();
}

class _ManarState extends State<Manar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  Future<void> load() async {
    final l = await Supabase.instance.client
        .from('Mero')
        .select()
        .eq('meal_name', 'burger');
    print(l);
    final data = modelFromJson(json.encode(l));
    print(data[0].rating);
    final R = Model(
      mealName: 'indomie',
      rating: 5,
      feedback: 'very good',
      customerName: 'Manar',
      customerNumber: '01061346948',
    );
    await Supabase.instance.client.from('Mero').insert(R.toJson());
    print('movie uploaded');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
