import 'package:vania/vania.dart';

class CreateMediaTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('media', () {
      id();
      integer('post_id');
      mediumText('url');
      char('type');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('media');
  }
}
