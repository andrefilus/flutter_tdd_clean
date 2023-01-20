import 'package:meta/meta.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  // final String body;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = { 'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method:'post', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map body
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    //arrange
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
    //act
    await sut.auth(params);

    //assert
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: { 'email': params.email, 'password': params.password}
    ));
  });
}