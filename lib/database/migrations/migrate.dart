import 'dart:io';
import 'package:vania/vania.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_posts_table.dart';
import 'create_categories_table.dart';
import 'create_post_categories_table.dart';
import 'create_comments_table.dart';
import 'create_media_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUserTable().up();
		 await CreatePersonalAccessTokensTable().up();
		 await CreatePostsTable().up();
		 await CreateCategoriesTable().up();
		 await CreatePostCategoriesTable().up();
		 await CreateCommentsTable().up();
		 await CreateMediaTable().up();
	}

    dropTables() async {
		 await CreateMediaTable().down();
		 await CreateCommentsTable().down();
		 await CreatePostCategoriesTable().down();
		 await CreateCategoriesTable().down();
		 await CreatePostsTable().down();
		 await CreatePersonalAccessTokensTable().down();
		 await CreateUserTable().down();
	 }
}
