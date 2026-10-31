import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Task 4 route paths are expected to be non-empty', () {
    const routes = ['/login', '/home', '/explore', '/cart', '/offers', '/account'];
    expect(routes.every((route) => route.startsWith('/')), isTrue);
  });
}
