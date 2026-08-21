import 'package:flutter/material.dart';
import 'package:maa_design_stitch_viewer/app/core/theme/app_size.dart';

abstract class AppBorderRadius {
  static const Radius radius4 = Radius.circular(AppSize.size4);
  static const Radius radius6 = Radius.circular(AppSize.size6);
  static const Radius radius8 = Radius.circular(AppSize.size8);
  static const Radius radius10 = Radius.circular(AppSize.size10);
  static const Radius radius12 = Radius.circular(AppSize.size12);
  static const Radius radius14 = Radius.circular(AppSize.size14);
  static const Radius radius16 = Radius.circular(AppSize.size16);
  static const Radius radius20 = Radius.circular(AppSize.size20);
  static const Radius radius24 = Radius.circular(AppSize.size24);
  static const Radius radius32 = Radius.circular(AppSize.size32);
  static const Radius radiusFull = Radius.circular(999.0);

  static const BorderRadius borderRadius4 = BorderRadius.all(radius4);
  static const BorderRadius borderRadius6 = BorderRadius.all(radius6);
  static const BorderRadius borderRadius8 = BorderRadius.all(radius8);
  static const BorderRadius borderRadius10 = BorderRadius.all(radius10);
  static const BorderRadius borderRadius12 = BorderRadius.all(radius12);
  static const BorderRadius borderRadius14 = BorderRadius.all(radius14);
  static const BorderRadius borderRadius16 = BorderRadius.all(radius16);
  static const BorderRadius borderRadius20 = BorderRadius.all(radius20);
  static const BorderRadius borderRadius24 = BorderRadius.all(radius24);
  static const BorderRadius borderRadius32 = BorderRadius.all(radius32);
  static const BorderRadius borderRadiusFull = BorderRadius.all(radiusFull);
}
