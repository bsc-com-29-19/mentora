import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mentora_frontend/activity/viewmodels/activities_view_model.dart';
import 'package:mentora_frontend/utils/api_endpoints.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ActivitiesController', () {
    // SharedPreferences.setMockInitialValues({});
    late MockClient mockClient;
    late ActivitiesController activitiesController;

    // setUp(() {
    //   when(mockClient.get(any, headers: anyNamed('headers')))
    //       .thenAnswer((_) async => http.Response('[]', 200));
    // });
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockClient = MockClient();
      activitiesController = ActivitiesController(client: mockClient);

      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('[]', 200));

      when(mockClient.patch(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));
    });

    test('fetchActivities', () async {
      await activitiesController.fetchActivities();
      expect(activitiesController.activities.value, []);
    });

    // test('updateActivityStatus', () async {
    //   await activitiesController.updateActivityStatus('123', 'done');
    //   verify(mockClient.patch(
    //     Uri.parse(ApiEndpoints.baseurl +
    //         ApiEndpoints.activityEndpoints.updateActivity('123')),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer ',
    //     },
    //     body: jsonEncode({'status': 'done'}),
    //   )).called(matcher);
    // });
  });
}

class MockClient extends Mock implements http.Client {}
