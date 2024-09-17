import 'package:vania/vania.dart';
import 'package:simple_blog_back/route/api_route.dart';
import 'package:simple_blog_back/route/web.dart';
import 'package:simple_blog_back/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}
