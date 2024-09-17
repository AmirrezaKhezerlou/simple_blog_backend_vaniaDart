import 'package:simple_blog_back/app/models/user.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class RegisterController extends Controller {
  Future<Response> index(Request request) async {
    try {
      request.validate({
        'email': 'required|email',
        'password': 'required|max_length:16',
        'username': 'required|alpha|max_length:20',
        'role': 'required',
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
      final String username = request.input('username');
      String password = Hash().make(request.input('password'));
      final String role = request.input('role');
      final String email = request.input('email');
      //INSERTING...
      var user = await User().query().where('email', '=', email).first();
      if (user != null) {
        return Response.json(
            {"messege": "User is already exist", "result": false}, 201);
      }
      await User().query().insert({
        'email': email,
        'username': username,
        'password': password,
        'role': role,
        'created_at': DateTime.now(),
      });
      return Response.json(
          {"messege": "Registerd Successfully", "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final RegisterController registerController = RegisterController();
