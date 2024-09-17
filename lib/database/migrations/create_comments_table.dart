import 'package:vania/vania.dart';

class CreateCommentsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('comments', () {
      id();
      integer('post_id');
      integer('user_id');
      longText('content');
      dateTime('created_at');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('comments');
  }
}
