import 'package:simple_blog_back/app/models/categories.dart';
import 'package:simple_blog_back/app/models/post_categories.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class PostCategoriesController extends Controller {
  Future<Response> getCategoryPosts(Request request) async {
    try {
      request.validate({"category_id": "required|numeric"});
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

    final int categoryId = request.input('category_id');
    var result = await PostCategories()
        .query()
        .select()
        .where('category_id', '=', categoryId)
        .get();
    return Response.json({'message': result, "result": true}, 200);
  }

  Future<Response> getPostCatagory(Request request) async {
    request.validate({"post_id": "required|numeric"});
    int postId = request.input('post_id');
    var result = await PostCategories()
        .query()
        .select()
        .where('post_id', '=', postId)
        .first();
    final int categoryId = result!['category_id'];
    var category = await Categories()
        .query()
        .select()
        .where('id', '=', categoryId)
        .first();
    return Response.json({
      "message": category,
      "result": true,
    }, 200);
  }
}

final PostCategoriesController postCategoriesController =
    PostCategoriesController();
