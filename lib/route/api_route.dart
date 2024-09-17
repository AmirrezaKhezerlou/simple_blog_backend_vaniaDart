import 'package:simple_blog_back/app/http/controllers/categories_controller.dart';
import 'package:simple_blog_back/app/http/controllers/comments_controller.dart';
import 'package:simple_blog_back/app/http/controllers/login_controller.dart';
import 'package:simple_blog_back/app/http/controllers/post_categories_controller.dart';
import 'package:simple_blog_back/app/http/controllers/posts_controller.dart';
import 'package:simple_blog_back/app/http/controllers/register_controller.dart';
import 'package:simple_blog_back/app/http/controllers/user_controller.dart';
import 'package:simple_blog_back/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');
    //Auth and user controller
    Router.group(() {
      Router.post('/register', registerController.index);
      Router.post('/login', loginController.index);
      //To update user profile details(for all users)
      Router.patch('/user', userController.updateUserProfile)
          .middleware([AuthenticateMiddleware()]);
    });

    //Posts Router Group:
    Router.group(() {
      //To get all posts
      Router.get('/posts', postsController.index);
      //to send new posts (only admin role can do)
      Router.post('/posts', postsController.newPost);
      //to get some count of posts
      Router.get('/posts/{count}', postsController.fetchRandomPosts);
      //to get spesific post
      Router.get('/posts/get_post/{id}', postsController.getSpesificPost);
      //to delete spesific post(only admins can do)
      Router.delete('/posts/{id}', postsController.deletePost);
      //to update spesific post(only author(must be admin)can do)
      Router.patch('/posts', postsController.patchSpesificPost);
    }, middleware: [AuthenticateMiddleware()]);

    //Categories Group
    Router.group(() {
      //to see all categories
      Router.get('/categories', categoriesController.index);
      //to add new category(only admins can do)
      Router.post('/categories', categoriesController.addCategory);
      //to delete a category(only admins can do)
      Router.delete('/categories/{id}', categoriesController.deleteCategory);
      //to edit category(only admins can do)
      Router.patch('/categories', categoriesController.patchSpesificCategory);
    }, middleware: [AuthenticateMiddleware()]);

    //post categories Group
    Router.group(() {
      //to get spesific categories posts
      Router.post('/category_post', postCategoriesController.getCategoryPosts);
      //to get spesific posts category
      Router.post('/posts_category', postCategoriesController.getPostCatagory);
    }, middleware: [AuthenticateMiddleware()]);

    //Comments Group
    Router.group(() {
      //to submit new comment
      Router.post('/comments', commentsController.newComment);
      Router.delete('/comments', commentsController.deleteComment);
      Router.get('/comments/{id}', commentsController.getComments);
    });
  }
}
