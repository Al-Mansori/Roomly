
import '../../../map/presentaion/services/geocoding_service.dart';
import 'address_resolver.dart';

class HomeConstants {
  // API URLs
  static const String nearbyWorkspacesUrl =
      'https://mostafaabdelkawy-roomly-ai.hf.space/api/v1/recommendations/nearby?';

  static const String topRatedWorkspacesUrl =
      'https://mostafaabdelkawy-roomly-ai.hf.space/api/v1/recommendations/ratings?';

  static const String workspaceImageUrl =
      'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/images/workspace?';

  static const String workspaceDetailsUrl =
      'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/customer/workspace/details?';



  /// ✅ Get default location dynamically
  static Future<LocationCoordinates> getDefaultCoordinates() async {
    final coords = await AddressResolver().resolveAddressToCoordinates();
    return coords ?? LocationCoordinates(
      latitude: 30.0785159,
      longitude: 31.1824923,
    );
  }

  // Database
  static const String databaseName = 'workspace_app.db';
  static const int databaseVersion = 2;

  // Table names
  static const String workspacesTable = 'workspaces';
  static const String roomsTable = 'rooms';
  static const String roomImagesTable = 'room_images';

  // Error messages
  static const String networkErrorMessage = 'error connecting to server';
  static const String serverErrorMessage = 'error in server';
  static const String unknownErrorMessage = 'unknown error';
  static const String noDataFoundMessage = 'there is no available data';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;
}
