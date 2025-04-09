// TODO: Put public facing types in this file.


import 'package:flutter/foundation.dart';

/// Checks which UI to render.
class AppSystem {
  static bool get isMaterial => TargetPlatform.android==defaultTargetPlatform;
  static bool get isCupertino => TargetPlatform.iOS==defaultTargetPlatform;
}
