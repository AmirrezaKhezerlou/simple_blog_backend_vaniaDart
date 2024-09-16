# Blog Backend with Vania Framework

This project is a backend service for a blog-like website, developed using the [Vania Framework](https://pub.dev/packages/vania) in Dart. It includes essential features such as user management, post creation, categorization, tagging, and media handling. The backend is designed to be lightweight, efficient, and scalable.

## Features

- **User Management**: Handles user registration, authentication, and role management (admin, author).
- **Post Management**: Create, update, delete, and view blog posts with support for rich content.
- **Category Management**: Organize blog posts into categories.
- **Tagging**: Tag posts with multiple keywords for better categorization and searchability.
- **Comments System**: Allows users to comment on blog posts.
- **Media Handling**: Support for image and file uploads linked to posts.
- **RESTful API**: Provides a clean, REST-compliant API for frontend communication.
  
## Project Structure

The project follows a clean architecture using Vania’s routing system. Here’s an overview of the main directories:

```bash
.
├── lib/
│   ├── controllers/        # Request handlers for various resources
│   ├── models/             # Data models for users, posts, categories, etc.
│   ├── services/           # Business logic for user authentication, post management, etc.
│   └── routes.dart         # API routes definition
├── test/                   # Unit and integration tests
├── pubspec.yaml            # Dart dependencies
└── README.md               # Project documentation
