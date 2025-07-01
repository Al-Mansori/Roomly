import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/map/presentaion/services/cubic/search_location_result.dart';
import 'package:roomly/features/map/presentaion/services/secure_storage_service.dart';
import '../geocoding_service.dart';
import '../location_manager.dart';
import '../state/location_event.dart';
import '../state/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationManager locationManager;
  final SecureStorageAddressServices _storageService = SecureStorageAddressServices();


  LocationBloc({required this.locationManager}) : super(const LocationInitial()) {
    on<LoadInitialLocation>(_onLoadInitialLocation);
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<SearchLocations>(_onSearchLocations);
    on<SelectSearchResult>(_onSelectSearchResult);
    on<SelectLocationOnMap>(_onSelectLocationOnMap);
    on<SaveSelectedLocation>(_onSaveSelectedLocation);
    on<ResetSearchState>(_onResetSearchState);
  }

  Future<void> _onLoadInitialLocation(
      LoadInitialLocation event, Emitter<LocationState> emit) async {
    emit(const LocationLoading());
    try {
      final result = await locationManager.getInitialUserLocation();
      emit(LocationLoaded(
        latitude: result.latitude,
        longitude: result.longitude,
        locationName: result.locationName,
        // address: result.address,
      ));
    } catch (e) {
      emit(LocationError('فشل في تحميل الموقع الأولي'));
    }
  }

  Future<void> _onGetCurrentLocation(
      GetCurrentLocation event, Emitter<LocationState> emit) async {

    emit(const LocationLoading());
    try {
      final position = await locationManager.getCurrentLocation();
      if (position == null) {
        emit(LocationError('تعذر الحصول على الموقع الحالي'));
        return;
      }
      final address = await locationManager
          .getDetailedLocationInfo(position.latitude, position.longitude);
      emit(LocationLoaded(
        latitude: position.latitude,
        longitude: position.longitude,
        locationName: address?.formattedAddress ?? 'الموقع الحالي',
        address: address?.formattedAddress,
        // street: address?.street,

      ));
    } catch (e) {
      emit(LocationError('فشل في الحصول على الموقع الحالي'));
    }
  }


  Future<void> _onSearchLocations(
      SearchLocations event, Emitter<LocationState> emit) async {
    emit(const LocationSearching());
    try {
      final results = await locationManager.searchLocations(event.query);
      emit(LocationSearchResults(results.cast<SearchLocationResult>()));
    } catch (e) {
      emit(LocationError('error searching'));
    }
  }

  void _onSelectSearchResult(
      SelectSearchResult event, Emitter<LocationState> emit) {
    _storageService.saveUserAddressForSearch(
      latitude: event.latitude,
      longitude: event.longitude,
      locationName: event.displayName,
      address: event.address,
    );

    emit(LocationSelected(
      latitude: event.latitude,
      longitude: event.longitude,
      locationName: event.displayName,
      address: event.address,
    ));
  }


  Future<void> _onSelectLocationOnMap(
      SelectLocationOnMap event,
      Emitter<LocationState> emit,
      ) async {
    try {
      final geocodingService = GeocodingService();
      final address = await geocodingService.getDetailedLocationInfo(
        event.latitude,
        event.longitude,
      );

      final isReadable = address != null && !address.formattedAddress.contains('+');

      emit(LocationSelected(
        latitude: event.latitude,
        longitude: event.longitude,
        locationName: isReadable ? address!.formattedAddress : 'موقع محدد على الخريطة',
        address: address?.formattedAddress,
        street: address?.street, // 👈 أضف الشارع هنا
      ));
    } catch (e) {
      emit(LocationError('فشل في اختيار الموقع من الخريطة'));
    }
  }


  Future<void> _onSaveSelectedLocation(
      SaveSelectedLocation event, Emitter<LocationState> emit) async {
    emit(LocationSaving(
      latitude: event.latitude,
      longitude: event.longitude,
      locationName: event.locationName,
    ));
    try {
      final success = await locationManager.updateUserLocation(
        latitude: event.latitude,
        longitude: event.longitude,
        address: event.address,
        locationName: event.locationName,
      );
      if (success) {
        emit(LocationSaved(
          latitude: event.latitude,
          longitude: event.longitude,
          locationName: event.locationName,
          street: event.address,
        ));
      } else {
        emit(LocationError('فشل في حفظ الموقع'));
      }
    } catch (e) {
      emit(LocationError('فشل في حفظ الموقع'));
    }
  }

  void _onResetSearchState(
      ResetSearchState event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      final current = state as LocationLoaded;
      emit(LocationLoaded(
        latitude: current.latitude,
        longitude: current.longitude,
        locationName: current.locationName,
        address: current.address,
      ));
    }
  }
}
