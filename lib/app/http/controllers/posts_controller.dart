import 'package:simple_blog_back/app/models/media.dart';
import 'package:simple_blog_back/app/models/post_categories.dart';
import 'package:simple_blog_back/app/models/posts.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class PostsController extends Controller {
  //To fetch all posts for main page of website
  Future<Response> index(Request request) async {
    try {
      var result = await Posts().query().select(['*']).get();
      for (final e in result) {
        var media = await Media()
            .query()
            .select()
            .where('post_id', '=', e['id'])
            .first();

        e.addAll({"media": media!['url']});
      }
      return Response.json({'message': result, "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  //To create a new post
  Future<Response> newPost(Request request) async {
    try {
      request.validate({
        'title': 'required|string',
        'content': 'required|string',
        'author_id': 'required|numeric',
        'category_id': 'required|numeric',
        "file": "required|file:jpg,jpeg,png,mp4"
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
      final String title = request.input('title');
      final String content = request.input('content');
      final int authorId = request.input('author_id');
      final int categoryId = request.input('category_id');
      RequestFile? file = request.file('file');
      String filePath = '';
      if (Auth().user()!['role'] == 'admin') {
        var time = DateTime.now();
        await Posts().query().insert({
          "title": title,
          "content": content,
          "author_id": authorId,
          "created_at": time,
          "updated_at": time,
        });

        var post = await Posts()
            .query()
            .select(['id'])
            .where('created_at', '=', time)
            .first();
        int postId = post!['id'];
        if (file != null) {
          filePath = await file.move(
              path: publicPath('images'), filename: file.getClientOriginalName);
          await Media().query().insert({
            "post_id": postId,
            "url": filePath,
            "type": file.getClientOriginalExtension
          });
        }
        await PostCategories().query().insert({
          "post_id": postId,
          "category_id": categoryId,
        });
        return Response.json(
            {"messasge": "post added succesfully", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only admin can send post", "result": false}, 403);
      }
    } catch (e) {
      print(e);
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  //Get Random Posts
  Future<Response> fetchRandomPosts(Request request, int count) async {
    try {
      var result = await Posts().query().select(['*']).limit(count).get();
      for (final e in result) {
        var media = await Media()
            .query()
            .select()
            .where('post_id', '=', e['id'])
            .first();
        e.addAll({"media": media!['url']});
      }
      return Response.json({'message': result, "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  //Delete a Post
  Future<Response> deletePost(Request request, int id) async {
    try {
      var res = await Posts().query().select().where('id', '=', id).get();
      if (res.isEmpty) {
        return Response.json(
            {'message': "post not found", "result": false}, 404);
      }
      if (Auth().user()!['role'] == 'admin') {
        await Posts().query().delete(id);
        return Response.json({'message': "post deleted", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only admins can delete posts", "result": false}, 403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> getSpesificPost(Request request, int id) async {
    try {
      var res = await Posts().query().select().where('id', '=', id).get();
      if (res.isEmpty) {
        return Response.json(
            {'message': "post not found", "result": false}, 404);
      }

      var media = await Media()
          .query()
          .select()
          .where('post_id', '=', res[0]['id'])
          .first();
      res[0]['id'].addAll({"media": media!['url']});

      return Response.json({'message': res, "result": true}, 200);
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }

  Future<Response> patchSpesificPost(Request request) async {
    try {
      request.validate({
        'title': 'required|string',
        'content': 'required|string',
        'author_id': 'required|numeric',
        "file": "file:jpg,jpeg,png,mp4",
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
      final String title = request.input('title');
      final String content = request.input('content');
      final int authorId = request.input('author_id');
      RequestFile? file = request.file('file');
      String filePath = '';
      if (file != null) {
        var result =
            await Media().query().select().where('post_id', '=', id).first();
        await Media().query().delete(result!['id']);
        filePath = await file.store(
            path: 'users/${Auth().id()}', filename: file.getClientOriginalName);
        await Media().query().insert({
          "post_id": id,
          "url": filePath,
          "type": file.getClientOriginalExtension
        });
      }
      if (Auth().user()!['id'] == authorId &&
          Auth().user()!['role'] == 'admin') {
        await Posts().query().update({
          "id": id,
          "title": title,
          "content": content,
          "author_id": authorId,
          "created_at": DateTime.now(),
          "updated_at": DateTime.now(),
        });

        return Response.json(
            {"messasge": "post edited succesfully", "result": true}, 200);
      } else {
        return Response.json(
            {"message": "only author can edit post", "result": false}, 403);
      }
    } catch (e) {
      return Response.json({"message": "unknown error", "result": false}, 520);
    }
  }
}

final PostsController postsController = PostsController();
