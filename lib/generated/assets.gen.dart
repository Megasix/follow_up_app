/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering

import 'package:flutter/widgets.dart';

class $AssetsGoogleMapsThemesGen {
  const $AssetsGoogleMapsThemesGen();

  String get dark => 'assets/googleMapsThemes/dark.json';
  String get light => 'assets/googleMapsThemes/light.json';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get darkFollowUpLogo01 =>
      const AssetGenImage('assets/images/Dark_Follow_Up_logo-01.png');
  AssetGenImage get darkFollowUpLogo02 =>
      const AssetGenImage('assets/images/Dark_Follow_Up_logo-02.png');
  AssetGenImage get darkFollowUpLogo03 =>
      const AssetGenImage('assets/images/Dark_Follow_Up_logo-03.png');
  AssetGenImage get followUpLogo01 =>
      const AssetGenImage('assets/images/Follow_Up_logo-01.png');
  AssetGenImage get followUpLogo02 =>
      const AssetGenImage('assets/images/Follow_Up_logo-02.png');
  AssetGenImage get followUpLogo03 =>
      const AssetGenImage('assets/images/Follow_Up_logo-03.png');
  AssetGenImage get twitterLogoBlue =>
      const AssetGenImage('assets/images/Twitter_Logo_Blue.png');
  AssetGenImage get appleLogoBlack =>
      const AssetGenImage('assets/images/apple_logo_black.png');
  AssetGenImage get appleLogoWhite =>
      const AssetGenImage('assets/images/apple_logo_white.png');
  AssetGenImage get flogoHexRBGWht100 =>
      const AssetGenImage('assets/images/flogo-HexRBG-Wht-100.png');
  AssetGenImage get googleLogo =>
      const AssetGenImage('assets/images/google-logo.png');
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  String get arrowDark => 'assets/lottie/arrow_dark.json';
  String get arrowLight => 'assets/lottie/arrow_light.json';
  String get carVrooming => 'assets/lottie/car_vrooming.json';
}

class Assets {
  Assets._();

  static const $AssetsGoogleMapsThemesGen googleMapsThemes =
      $AssetsGoogleMapsThemesGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
