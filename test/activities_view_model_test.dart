import 'package:flutter_test/flutter_test.dart';
import 'package:mentora_frontend/activity/viewmodels/activities_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:get/get.dart';
//
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late ActivitiesController activitiesController;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    activitiesController = ActivitiesController();
  });

  test('Token exists in SharedPreferences', () async {
    // Arrange
    SharedPreferences.setMockInitialValues({
      'token': 'token',
      'username': 'username',
      'email': 'email',
      'fullName': 'fullName',
    });

    // Act
    final token = await activitiesController.loadToken();

    // Assert
    expect(token, 'token');
    expect(activitiesController.username.value, 'username');
    expect(activitiesController.email.value, 'email');
    expect(activitiesController.fullName.value, 'fullName');
    expect(activitiesController.errorMessage.value, '');
  });

  test('Token does not exist in SharedPreferences', () async {
    // Arrange
    when(mockSharedPreferences.getString('token') as Function()).thenReturn(null);
    when(mockSharedPreferences.getString('username') as Function()).thenReturn(null);
    when(mockSharedPreferences.getString('email') as Function()).thenReturn(null);
    when(mockSharedPreferences.getString('fullName') as Function()).thenReturn(null);
    SharedPreferences.setMockInitialValues({});

    // Act
    final token = await activitiesController.loadToken();

    // Assert
    expect(token, null);
    expect(activitiesController.username.value, 'User');
    expect(activitiesController.email.value, 'email@example.com');
    expect(activitiesController.fullName.value, 'Full Name');
    expect(activitiesController.errorMessage.value,
        'Token is missing. Please log in again.');
  });

  test('Token is empty in SharedPreferences', () async {
    // Arrange
    when(mockSharedPreferences.getString('token') as Function()).thenReturn('');
    when(mockSharedPreferences.getString('username') as Function()).thenReturn('');
    when(mockSharedPreferences.getString('email') as Function()).thenReturn('');
    when(mockSharedPreferences.getString('fullName') as Function()).thenReturn('');
    SharedPreferences.setMockInitialValues({});

    // Act
    final token = await activitiesController.loadToken();

    // Assert
    expect(token, null);
    expect(activitiesController.username.value, 'User');
    expect(activitiesController.email.value, 'email@example.com');
    expect(activitiesController.fullName.value, 'Full Name');
    expect(activitiesController.errorMessage.value,
        'Token is missing. Please log in again.');
  });

  test('SharedPreferences returns null for token', () async {
    // Arrange
    SharedPreferences.setMockInitialValues({});

    // Act and Assert
    final result = await activitiesController.loadToken();

    // Assert: Verify no exception is thrown, but token is null
    expect(result, isNull);
    expect(activitiesController.errorMessage.value,
        "Token is missing. Please log in again.");
  });
}
