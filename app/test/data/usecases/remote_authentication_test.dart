import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/domain/helpers/helpers.dart';
import 'package:app/domain/usecases/usecases.dart';

import 'package:app/data/http/http.dart';
import 'package:app/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    //arrange
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), 
      password: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    //act
    await sut.auth(params);

    //assert
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: { 'email': params.email, 'password': params.password}
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: anyNamed('url'), 
      method: anyNamed('method'), body: anyNamed('body')))
    .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(email: faker.internet.email(), 
      password: faker.internet.password());
    //act
    final future = sut.auth(params);


    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), 
      body: anyNamed('body')))
      .thenThrow(HttpError.notFound);

    final params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
    //act
    final future = sut.auth(params);


    expect(future, throwsA(DomainError.unexpected));
  });

}