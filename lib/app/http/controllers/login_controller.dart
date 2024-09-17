import 'package:simple_blog_back/app/models/user.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class LoginController extends Controller {
  Future<Response> index(Request request) async {
    try {
      request.validate({
        'password': 'required|max_length:16',
        'username': 'required|alpha|max_length:20',
      });
    } catch (e) {
      if (e is ValidationException) {
        String errorMessage = e.message;
        int code = e.code;
        return Response.json({"message": errorMessage, "result": false}, code);
      } else {
        return Response.json(
            {"message": "unknown error", "result": false}, 520);
      }
    }

    try {
      String username = request.input('username');
      String password = request.input('password');
      var user = await User().query().where('username', '=', username).first();
      if (user == null) {
        //user is null
        return Response.json(
            {"message": "user not found", "result": false}, 404);
      }

      if (Hash().verify(password, user['password'])) {
        final auth = Auth().login(user);
        final token = await auth.createToken(expiresIn: Duration(days: 90));
        user.removeWhere((key, value) => key == 'password');
        return Response.json(
            {"message": user, "result": true, "token": token["access_token"]});
      } else {
        return Response.json(
            {"message": "username or password is wrong", "result": false}, 404);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final LoginController loginController = LoginController();
