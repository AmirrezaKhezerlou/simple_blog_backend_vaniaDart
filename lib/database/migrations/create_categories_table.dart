import 'package:vania/vania.dart';

class CreateCategoriesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('categories', () {
      id();
      char('name');
      tinyText('slug');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('categories');
  }
}
