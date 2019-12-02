/**
 *
 * Eddie, enguagns2@gmail.com
 *
 *
 */

import 'package:flutter/material.dart';

/// Created On 2019/12/2
/// Description: Config
///
class Config {
  /// Chat Type
  static const CHAT_TYPE_UNKNOWN = 'unknown';
  static const CHAT_TYPE_TEXT = 'text';
  static const CHAT_TYPE_IMAGE = 'image';
  static const CHAT_TYPE_AUDIO = 'audio';
  static const CHAT_TYPE_VIDEO = 'video';
  static const CHAT_TYPE_TIP = 'tip';

  /// Color
  static const primaryColor = Color(0xFF5EB8C2);
  static const chat_bg = Color(0xFFF2F2F2);
  static const chat_bg_me = Color(0xFFFFFFFF);
  static const chat_text_me = Color(0xFF424242);
  static const chat_bg_other = Color(0xFF9EEA6A);
  static const chat_text_other = Color(0xFF000000);

  /// Default text size
  static const commonTextSize = 16.0;

  /// Big text size
  static const bigTextSize_1 = commonTextSize + 1; // 17.0
  static const bigTextSize_2 = commonTextSize + 2; // 18.0
  static const bigTextSize_3 = commonTextSize + 3; // 19.0
  static const bigTextSize_4 = commonTextSize + 4; // 20.0
  static const bigTextSize_8 = commonTextSize + 8; // 24.0
  static const bigTextSize_16 = commonTextSize + 16; // 32.0
  static const bigTextSize_32 = commonTextSize + 32; // 48.0
  static const bigTextSize_36 = commonTextSize + 36; // 52.0

  /// Small text size
  static const smallTextSize_1 = commonTextSize - 1; // 15.0
  static const smallTextSize_2 = commonTextSize - 2; // 14.0
  static const smallTextSize_3 = commonTextSize - 3; // 13.0
  static const smallTextSize_4 = commonTextSize - 4; // 12.0
  static const smallTextSize_5 = commonTextSize - 5; // 11.0
  static const smallTextSize_6 = commonTextSize - 6; // 10.0

  /// UI Border
  static const BorderRadius borderRadiusOthers = BorderRadius.only(
    bottomLeft: Radius.circular(8.0),
    topRight: Radius.circular(8.0),
    bottomRight: Radius.circular(8.0),
  );
  static const BorderRadius borderRadiusMe = BorderRadius.only(
    bottomLeft: Radius.circular(8.0),
    topLeft: Radius.circular(8.0),
    bottomRight: Radius.circular(8.0),
  );

  /// Chat assets
  static const chatBgAssets = 'assets/bg_chat.png';
  static const chatMeAvatarAssets = 'assets/avatar_1.jpg';
  static const chatOtherAvatarAssets = 'assets/avatar_2.jpg';

  /// Net Image
  static const netImageAddress1 =
      'https://user-gold-cdn.xitu.io/2019/11/30/16eba8fbaa9b4440?w=1080&h=1920&f=jpeg&s=388076';
  static const netImageAddress2 =
      'https://user-gold-cdn.xitu.io/2019/11/30/16eba8fbaa9b4440?w=1080&h=1920&f=jpeg&s=388076';

  /// Net Audio
  static const netAudioAddress1 =
      'https://user-gold-cdn.xitu.io/2019/11/30/16eba8fbaa9b4440?w=1080&h=1920&f=jpeg&s=388076';

  /// Net Video
  static const netVideoAddress1 =
      'https://user-gold-cdn.xitu.io/2019/11/30/16eba8fbaa9b4440?w=1080&h=1920&f=jpeg&s=388076';
}
