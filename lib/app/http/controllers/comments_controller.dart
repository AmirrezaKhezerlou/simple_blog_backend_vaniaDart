import 'package:simple_blog_back/app/models/comments.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CommentsController extends Controller {
  Future<Response> newComment(Request request) async {
    try {
      request.validate({
        "post_id": "required|numeric",
        "user_id": "required|numeric",
        "content": "required|string",
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
      final int postId = request.input('post_id');
      final int userid = request.input('user_id');
      final String content = request.input('content');
      await Comments().query().insert({
        "post_id": postId,
        "user_id": userid,
        "content": content,
        "created_at": DateTime.now(),
      });
      return Response.json({"message": "comment added", "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> deleteComment(Request request) async {
    try {
      request.validate({
        "id": "required|numeric",
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
      final int commentId = request.input('id');
      var comment =
          await Comments().query().select().where('id', '=', commentId).first();
      var commentAuthorId = comment!['user_id'];
      var requesterId = Auth().user()!['id'];
      if (requesterId == commentAuthorId || Auth().user()!['role'] == 'admin') {
        await Comments().query().delete(comment['id']);
        return Response.json(
            {'message': "comment deleted", "result": true}, 200);
      } else {
        return Response.json({
          'message': "only author or admin can delete comment",
          "result": false
        }, 403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> getComments(Request request, int id) async {
    try {
      var result =
          await Comments().query().select().where('post_id', '=', id).get();
      return Response.json({
        "message": result,
        "result": true,
      }, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final CommentsController commentsController = CommentsController();
