import 'package:dio/dio.dart';
import 'package:wine_app/data/spref/spref.dart';
import 'package:wine_app/shared/constant.dart';

class WineClient {
  static BaseOptions _options = new BaseOptions(
    // baseUrl: "http://localhost:8000",
    baseUrl: "http://172.20.10.4:8000",
    // headers: {
    //   "Access-Control-Allow-Origin":"http://192.168.1.11:8000",
    //   "Access-Control-Allow-Header":"Origin, X-Requested-With, Content-Type, Accept",
    //   "Content-Type": "application/json",
    //   "Accept": "application/json",
    // },
    // contentType: "application/json",
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
      token;
      return myOption;
    }));
  }
  static final WineClient instance = WineClient._internal();

  Dio get dio => _dio;
}
