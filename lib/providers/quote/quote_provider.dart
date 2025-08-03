import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import '../../model/quote/quote.dart';

part 'quote_provider.g.dart';

@riverpod
Future<Quote> getQuote(Ref ref) async {
  final url = Uri.parse('https://quotes-api-self.vercel.app/quote');
  final client = http.Client();
  ref.onDispose(() => client.close());
  await Future<dynamic>.delayed(const Duration(seconds: 1));
  final response = await client.get(url);
  if (response.statusCode == 200) {
    final json = response.body;
    return Quote.fromJson(jsonDecode(json));
  } else {
    throw Exception('Failed to load quote');
  }
}
