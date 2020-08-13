
import 'package:wine_app/base/base_event.dart';
import 'package:wine_app/shared/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent {
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}
