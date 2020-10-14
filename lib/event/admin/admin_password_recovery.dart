import 'package:wine_app/base/base_event.dart';

class AdminPasswordRecovery extends BaseEvent{
  String phone;
  AdminPasswordRecovery({this.phone});
}