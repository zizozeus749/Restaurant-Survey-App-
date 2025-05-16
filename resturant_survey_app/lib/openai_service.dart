import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _apiKey =
      'sk-proj-b0\_EtVLoCHrJZqLhiJW\_AEgNlk9Tq8c-uPt9t6YlaKZ-PO9pJQl5dTK776Tq-RPforthE0iqt-T3BlbkFJv20oJMT1Ac6YJA6UjOh\_gInCmjZK9uWuA3YS82ZNn0bWui8T\_\_WLJxAhI6Vg05ywRUXvaQtU8A';
  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';

  static Future<bool> isCommentConsistent(String comment, int rating) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful assistant that checks if a user review matches the given rating. High rating means the comment should be positive. Low rating means the comment should be negative or neutral.",
            },
            {
              "role": "user",
              "content":
                  "The user gave a rating of $rating out of 5 and wrote this comment: \"$comment\". Is the comment consistent with the rating? Reply only with Yes or No.",
            },
          ],
          "temperature": 0,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final choices = decoded['choices'];
        if (choices != null && choices.isNotEmpty) {
          final content =
              choices[0]['message']['content'].toString().toLowerCase();
          return content.contains('yes');
        } else {
          print("OpenAI response missing 'choices'");
        }
      } else {
        print("OpenAI HTTP error: ${response.statusCode} - ${response.body}");
      }

      return true; // علشان ما يوقفش البرنامج في حال فشل الاتصال أو استجابة غير متوقعة
    } catch (e) {
      print("OpenAI error: $e");
      return true;
    }
  }
}
