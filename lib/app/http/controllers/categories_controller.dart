import 'package:simple_blog_back/app/models/categories.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CategoriesController extends Controller {
  Future<Response> index() async {
    try {
      var result = await Categories().query().select(['*']).get();
      return Response.json({'message': result, 'result': true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> addCategory(Request request) async {
    try {
      request.validate({"name": 'required|string', "slug": "required|string"});
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
      final String name = request.input('name');
      final String slug = request.input('slut');
      if (Auth().user()!['role'] == 'admin') {
        await Categories().query().insert({
          "name": name,
          "slug": slug,
        });
        return Response.json(
            {"message": "category added", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only admin can send post", "result": false}, 403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  //Delete a category
  Future<Response> deleteCategory(Request request, int id) async {
    try {
      var res = await Categories().query().select().where('id', '=', id).get();
      if (res.isEmpty) {
        return Response.json(
            {'message': "category not found", "result": false}, 404);
      }
      if (Auth().user()!['role'] == 'admin') {
        await Categories().query().delete(id);
        return Response.json(
            {'message': "category deleted", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only admins can delete category", "result": false},
            403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> patchSpesificCategory(Request request) async {
    try {
      request.validate({
        'name': 'required|string',
        'slug': 'required|string',
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
      final int id = request.input('id');
      final String name = request.input('name');
      final String slug = request.input('slug');
      if (Auth().user()!['role'] == 'admin') {
        await Categories().query().update({
          "id": id,
          "name": name,
          "slug": slug,
        });
        return Response.json(
            {"messasge": "category edited succesfully", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only admins can edit categories", "result": false},
            403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final CategoriesController categoriesController = CategoriesController();
