import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/map/presentaion/services/cubic/location_bloc.dart';
import 'package:roomly/features/map/presentaion/services/cubic/search_location_result.dart';
import 'package:roomly/features/map/presentaion/services/geocoding_service.dart';
import 'package:roomly/features/map/presentaion/services/location_manager.dart';
import 'package:roomly/features/map/presentaion/services/state/location_event.dart';
import 'package:roomly/features/map/presentaion/services/state/location_state.dart';

class MapScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialLocationName;

  const MapScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialLocationName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  LatLng? _currentMapLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    loadInitialLocation();
  }

  Future<void> loadInitialLocation() async {
    final locationManager = LocationManager();


    // إذا لم يتم العثور على موقع محفوظ في البحث، جرب استرجاع الموقع المحفوظ العادي

    double latitude;
    double longitude;
    final result = await locationManager.getInitialUserLocation();
    latitude = result.latitude;
    longitude = result.longitude;

    // if (savedLocation != null) {
    //   latitude = savedLocation['latitude'];
    //   longitude = savedLocation['longitude'];
    // } else {
    //   final result = await locationManager.getInitialUserLocation();
    //   latitude = result.latitude;
    //   longitude = result.longitude;
    // }

    final geocodingService = GeocodingService();
    final locationName = await geocodingService.getAddressFromCoordinates(latitude, longitude)
        ?? 'Unknown location';

    setState(() {
      _currentMapLocation = LatLng(latitude, longitude);
    });

    _updateMarkers(_currentMapLocation!, locationName ?? 'Unknown location');
    _animateToLocation(_currentMapLocation!);
  }


  /// تحديث العلامات على الخريطة
  void _updateMarkers(LatLng location, String locationName) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: InfoWindow(
            title: locationName,
            snippet: 'selected location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }
  Future<void> _animateToLocation(LatLng location) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  /// البحث عن المواقع
  void _searchLocations(String query) {
    if (query.trim().isNotEmpty) {
      context.read<LocationBloc>().add(SearchLocations(query));
    } else {
      context.read<LocationBloc>().add(const ResetSearchState());
    }
  }

  /// تحديد موقع من نتائج البحث
  void _selectSearchResult(SearchLocationResult result) {
    context.read<LocationBloc>().add(SelectSearchResult(
      latitude: result.latitude,
      longitude: result.longitude,
      displayName: result.displayName,
      address: result.address,
    ));

    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  /// التعامل مع النقر على الخريطة
  void _onMapTap(LatLng location) {
    context.read<LocationBloc>().add(SelectLocationOnMap(
      latitude: location.latitude,
      longitude: location.longitude,
    ));
  }

  /// الحصول على الموقع الحالي من GPS
  void _getCurrentLocation() {
    context.read<LocationBloc>().add(const GetCurrentLocation());
  }

  /// حفظ الموقع المحدد والعودة
  void _saveAndReturn(LocationState state) {
    if (state is LocationSelected) {
      context.read<LocationBloc>().add(SaveSelectedLocation(
        latitude: state.latitude,
        longitude: state.longitude,
        locationName: state.locationName,
        address: state.address,
      ));
    }
  }

  /// عرض رسالة خطأ
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            _showErrorSnackBar(state.message);
          } else if (state is LocationSelected) {
            LatLng newLocation = LatLng(state.latitude, state.longitude);
            _currentMapLocation = newLocation;
            _updateMarkers(newLocation, state.locationName);
            _animateToLocation(newLocation);
          } else if (state is LocationSaved) {
            Navigator.of(context).pop({
              'latitude': state.latitude,
              'longitude': state.longitude,
              'locationName': state.locationName,
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _currentMapLocation == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  if (_currentMapLocation != null) {
                    _animateToLocation(_currentMapLocation!);
                  }
                },
                initialCameraPosition: CameraPosition(
                  target: _currentMapLocation ?? const LatLng(30.0384, 31.2108),
                  zoom: 15.0,
                ),
                markers: _markers,
                onTap: _onMapTap,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // شريط البحث العلوي
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    // شريط البحث
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // زر الرجوع
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back, color: Colors.black54),
                          ),
                          // حقل البحث
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'search for location...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onChanged: _searchLocations,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          // مؤشر التحميل أو أيقونة البحث
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: state is LocationSearching
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Icon(Icons.search, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // نتائج البحث
                    if (state is LocationSearchResults && state.results.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.results.length > 5 ? 5 : state.results.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            SearchLocationResult result = state.results[index];
                            return ListTile(
                              leading: const Icon(Icons.location_on, color: Colors.red),
                              title: Text(
                                result.displayName,
                                style: const TextStyle(fontSize: 14),
                                textDirection: TextDirection.rtl,
                              ),
                              subtitle: Text(
                                result.address,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                textDirection: TextDirection.rtl,
                              ),
                              onTap: () => _selectSearchResult(result),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // معلومات الموقع المحدد
              Positioned(
                bottom: 120,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildLocationInfo(state),
                ),
              ),

              // أزرار التحكم
              Positioned(
                bottom: 30,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    // زر الموقع الحالي
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // زر الحفظ
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (state is LocationSelected || state is LocationLoaded) &&
                            state is! LocationSaving
                            ? () => _saveAndReturn(state)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: state is LocationSaving
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Text(
                          'confirm location',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// بناء معلومات الموقع
  Widget _buildLocationInfo(LocationState state) {

    String locationName = 'loading...';
    double? latitude;
    double? longitude;

    if (state is LocationSelected) {
      locationName = state.locationName;
      latitude = state.latitude;
      longitude = state.longitude;
    } else if (state is LocationLoaded) {
      locationName = state.locationName;
      latitude = state.latitude;
      longitude = state.longitude;
    } else if (state is LocationSaving) {
      locationName = state.locationName;
      latitude = state.latitude;
      longitude = state.longitude;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                locationName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        if (latitude != null && longitude != null) ...[
          const SizedBox(height: 4),
          Text(
            'latitude: ${latitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textDirection: TextDirection.rtl,
          ),
          Text(
            'longitude: ${longitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textDirection: TextDirection.rtl,
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}

