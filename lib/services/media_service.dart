import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Owns on-device media files for the mood journal. Only file *paths* are stored
/// in Isar (on [MoodEntry]); the bytes live under the app documents directory so
/// they're private and travel with an app backup. Nothing leaves the device.
class MediaService {
  const MediaService._();

  static Future<Directory> _dir(String sub) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/media/$sub');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// A fresh path to record a voice note into (aac/.m4a).
  static Future<String> newAudioPath() async {
    final dir = await _dir('audio');
    return '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  /// Copy a picked/captured image into app storage and return the stored path.
  static Future<String> savePhoto(String sourcePath) async {
    final dir = await _dir('photos');
    final ext = sourcePath.contains('.') ? sourcePath.split('.').last : 'jpg';
    final dest = '${dir.path}/photo_${DateTime.now().millisecondsSinceEpoch}.$ext';
    await File(sourcePath).copy(dest);
    return dest;
  }

  /// Best-effort delete of a media file (e.g. when the user discards it).
  static Future<void> delete(String? path) async {
    if (path == null) return;
    final f = File(path);
    if (await f.exists()) await f.delete();
  }

  static bool exists(String? path) => path != null && File(path).existsSync();
}
