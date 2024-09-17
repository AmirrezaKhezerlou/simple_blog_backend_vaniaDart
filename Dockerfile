# Use latest stable channel SDK.
FROM dart:stable AS build

# Work Directory
WORKDIR /app

# Resolve app dependencies.
COPY pubspec.* ./

# Install the Vania cli from pub.dev
RUN dart pub global activate vania_cli

# Get dependencies
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

# 📦 Create a production build
RUN dart pub get --offline

# Comment the following line if you don't want to create tables.
RUN vania migrate

RUN vania build

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /bin/server
COPY --from=build /app/.env /

# Comment the following line if you are not serving static files.
COPY --from=build /app/public /public/
COPY --from=build /app/storage /storage/

# Expose the server port (useful for binding)
EXPOSE 8000

# Start server.
CMD ["/bin/server"]