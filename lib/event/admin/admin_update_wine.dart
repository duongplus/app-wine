import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/wine.dart';

class AdminUpdateWine extends BaseEvent{
  Wine wine;
  AdminUpdateWine({this.wine});
}