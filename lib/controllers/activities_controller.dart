import 'package:get/get.dart';
import '../../../models/trip_model.dart';

class ActivitiesController extends GetxController {
  var upcomingTrips = <Trip>[].obs;
  var completedTrips = <Trip>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTrips();
  }

  void loadTrips() {
    upcomingTrips.addAll([
      Trip(
        id: '1',
        type: 'Đi sân bay',
        startDate: DateTime.parse('2024-08-01T10:00:00'),
        endDate: DateTime.parse('2024-08-01T12:00:00'),
        departureLocation: 'Location A',
        destinationLocation: 'Location B',
        distance: 10.0,
        isCompleted: false,
      ),
      Trip(
        id: '2',
        type: 'Đi đường dài',
        startDate: DateTime.parse('2024-08-05T09:00:00'),
        endDate: DateTime.parse('2024-08-05T11:00:00'),
        departureLocation: 'Location C',
        destinationLocation: 'Location D',
        distance: 20.0,
        isCompleted: false,
      ),
    ]);

    completedTrips.addAll([
      Trip(
        id: '3',
        type: 'Đi sân bay',
        startDate: DateTime.parse('2024-07-01T08:00:00'),
        endDate: DateTime.parse('2024-07-01T10:00:00'),
        departureLocation: 'Location E',
        destinationLocation: 'Location F',
        distance: 15.0,
        isCompleted: true,
      ),
      Trip(
        id: '4',
        type: 'Đi đường dài',
        startDate: DateTime.parse('2024-07-05T07:00:00'),
        endDate: DateTime.parse('2024-07-05T09:00:00'),
        departureLocation: 'Location G',
        destinationLocation: 'Location H',
        distance: 25.0,
        isCompleted: true,
      ),
    ]);
  }

  void updateIndex(int index) {
    // Xử lý thay đổi tab nếu cần
  }

  void addUpcomingTrip(Trip trip) {
    upcomingTrips.add(trip);
  }

  void addCompletedTrip(Trip trip) {
    completedTrips.add(trip);
  }

  void removeUpcomingTrip(String id) {
    upcomingTrips.removeWhere((trip) => trip.id == id);
  }

  void removeCompletedTrip(String id) {
    completedTrips.removeWhere((trip) => trip.id == id);
  }

  void updateTrip(String id, Trip updatedTrip) {
    int upcomingIndex = upcomingTrips.indexWhere((trip) => trip.id == id);
    if (upcomingIndex != -1) {
      upcomingTrips[upcomingIndex] = updatedTrip;
    }

    int completedIndex = completedTrips.indexWhere((trip) => trip.id == id);
    if (completedIndex != -1) {
      completedTrips[completedIndex] = updatedTrip;
    }
  }
}
