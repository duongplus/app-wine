import 'package:dio/dio.dart';
import 'package:wine_app/data/spref/spref.dart';
import 'package:wine_app/shared/constant.dart';

class WineClient {
  static BaseOptions _options = new BaseOptions(
    baseUrl: "http://192.168.56.1:8000",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  static Dio _dio = Dio(_options);

  WineClient._internal() {
    //_dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options myOption) async {
      var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
      if (token != null) {
        myOption.headers["Authorization"] = "Bearer " + token;
      }

      return myOption;
    }));
  }
  static final WineClient instance = WineClient._internal();

  Dio get dio => _dio;
}
