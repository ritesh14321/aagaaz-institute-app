import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String projectUrl = 'https://xxabvaougzxcfxavyzta.supabase.co';
  static const String publishableKey = 'sb_publishable_MQarnDEQ2ZmElIJH2aF8pw_7DImBocp';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: projectUrl,
      anonKey: publishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
