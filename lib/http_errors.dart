import 'package:pocketbase/pocketbase.dart';

class BadRequest implements Exception {}

class Unauthorized implements Exception {}

void reraise(ClientException error) {
  switch (error.statusCode) {
    case 400:
      throw BadRequest();
    case 401:
      throw Unauthorized();
  }
}
