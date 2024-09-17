import 'package:vania/vania.dart';

class CreatePostCategoriesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('post_categories', () {
      id();
      integer('post_id');
      integer('category_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('post_categories');
  }
}
