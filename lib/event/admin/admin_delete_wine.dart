import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/wine.dart';

class AdminDeleteWine extends BaseEvent{
  String oid;
  AdminDeleteWine({this.oid});
}