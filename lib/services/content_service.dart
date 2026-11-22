import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/catalog.dart';
import '../models/course.dart';
import '../models/live_class.dart';

class RemoteBannerItem {
  const RemoteBannerItem({
    required this.id,
    required this.badge,
    required this.title,
    required this.subtitle,
    this.imageUrl = '',
    this.targetTab = 1,
  });

  final String id;
  final String badge;
  final String title;
  final String subtitle;
  final String imageUrl;
  final int targetTab;

  factory RemoteBannerItem.fromJson(Map<String, dynamic> json) {
    return RemoteBannerItem(
      id: (json['id'] ?? '').toString(),
      badge: (json['badge'] ?? 'UPDATE').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      targetTab: (json['targetTab'] is int)
          ? json['targetTab'] as int
          : int.tryParse((json['targetTab'] ?? '1').toString()) ?? 1,
    );
  }
}

class RemoteContentBundle {
  const RemoteContentBundle({
    required this.banners,
    required this.courses,
    required this.liveClasses,
    required this.raw,
  });

  final List<RemoteBannerItem> banners;
  final List<Course> courses;
  final List<LiveClass> liveClasses;
  final Map<String, dynamic> raw;
}

class ContentService {
  // Jab website/API endpoint tayyar ho jaye tab yahan apna real URL daal dein.
  static const String defaultFeedUrl =
      'https://www.aagaazinstitute.com/api/app-data.json';

  Future<RemoteContentBundle?> fetchBundle({
    String url = defaultFeedUrl,
  }) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
      return null;
    }

    try {
      final response = await http
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'Cache-Control': 'no-cache',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final parsedBanners = <RemoteBannerItem>[];
      if (decoded['banners'] is List) {
        for (final item in decoded['banners'] as List) {
          if (item is Map<String, dynamic>) {
            final banner = RemoteBannerItem.fromJson(item);
            if (banner.title.trim().isNotEmpty) {
              parsedBanners.add(banner);
            }
          }
        }
      }

      final parsedCourses = <Course>[];
      if (decoded['courses'] is List) {
        for (final item in decoded['courses'] as List) {
          if (item is Map<String, dynamic>) {
            final id = (item['id'] ?? '').toString().trim();
            final title = (item['title'] ?? '').toString().trim();
            if (id.isNotEmpty && title.isNotEmpty) {
              parsedCourses.add(
                Course(
                  id: id,
                  title: title,
                ),
              );
            }
          }
        }
      }

      final parsedLive = <LiveClass>[];
      if (decoded['liveClasses'] is List) {
        for (final item in decoded['liveClasses'] as List) {
          if (item is Map<String, dynamic>) {
            try {
              parsedLive.add(LiveClass.fromJson(item));
            } catch (_) {
              // Agar LiveClass.fromJson alag signature rakhta ho toh safe skip
            }
          }
        }
      }

      return RemoteContentBundle(
        banners: parsedBanners,
        courses: parsedCourses.isNotEmpty ? parsedCourses : Catalog.courses,
        liveClasses: parsedLive.isNotEmpty ? parsedLive : Catalog.liveClasses(),
        raw: decoded,
      );
    } catch (_) {
      return null;
    }
  }
}
