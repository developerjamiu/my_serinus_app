# Stage 1: Build the Dart application
FROM dart:stable AS build

WORKDIR /app

# Resolve dependencies first (cached layer)
COPY pubspec.* ./
RUN dart pub get

# Copy source code and compile
COPY . .
RUN dart build cli --target bin/my_serinus_app.dart -o output

# Stage 2: Create a minimal runtime image
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/

EXPOSE 8080

CMD ["/app/bin/server"]