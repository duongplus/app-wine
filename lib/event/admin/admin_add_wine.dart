import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/wine.dart';

class AdminAddWine extends BaseEvent{
  Wine wine;
  AdminAddWine({this.wine});
}