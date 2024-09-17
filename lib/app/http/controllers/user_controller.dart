import 'package:simple_blog_back/app/models/user.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class UserController extends Controller {
  Future<Response> updateUserProfile(Request request) async {
    try {
      request.validate({
        "user_id": "required|integer",
        'email': 'required|email',
        'username': 'required|alpha|max_length:20',
        "image": "required|file:jpg,jpeg,png"
      });
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        int code = e.code;
        return Response.json({"message": errorMessage, "result": false}, code);
      } else {
        return Response.json(
            {"message": "unknown error", "result": false}, 520);
      }
    }

    try {
      int userId = request.input('user_id');
      String userName = request.input("username");
      String email = request.input("email");
      RequestFile? file = request.file('image');
      String filePath = '';
      if (file != null) {
        filePath = await file.store(
            path: 'users/${Auth().id()}', filename: file.getClientOriginalName);
      }
      await User().query().update({
        "id": userId,
        "email": email,
        "username": userName,
        "image": filePath,
      });
      return Response.json(
          {"messasge": "profile edited succesfully", "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final UserController userController = UserController();
