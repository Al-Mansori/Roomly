import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/map/presentaion/services/cubic/location_bloc.dart';
import '../../../map/presentaion/services/state/location_event.dart';
import '../../../map/presentaion/services/state/location_state.dart';
import '../bloc/cubit/workspace_cubit.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        String locationName = 'dokki';
        if (state is LocationSaved) {
          locationName = state.street ?? state.locationName;
        }
        if (state is LocationLoaded) {
          locationName = state.street ?? state.locationName;
        } else if (state is LocationSelected) {
          locationName = state.street ?? state.locationName;
        } else if (state is LocationLoading) {
          locationName = 'loading...';
        } else if (state is LocationError) {
          locationName = 'error loading map';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(127, 0, 0, 0),
                    shape: BoxShape.circle,
                  ),
                  width: 45,
                  height: 45,
                  child: IconButton(
                    onPressed: () => _openMapScreen(context),
                    icon: SvgPicture.asset(
                      'assets/icons/location-arrow-solid.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    tooltip: 'location change',
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _openMapScreen(context),
                  child: Row(
                    children: [
                      Text(
                        _getFirstTwoWords(locationName),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (state is LocationLoading) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(127, 0, 0, 0),
                shape: BoxShape.circle,
              ),
              width: 45,
              height: 45,
              child: IconButton(
                onPressed: () => context.push('/profile'),
                // onPressed: () => print("Profile pressed"),
                icon: SvgPicture.asset(
                  'assets/icons/user-regular (1).svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn),
                ),
                tooltip: 'Personal Account',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openMapScreen(BuildContext context) async {
    final locationBloc = context.read<LocationBloc>();
    final workspaceCubit = context.read<WorkspaceCubit>(); // أضف هذا السطر
    final currentState = locationBloc.state;

    double? initialLatitude;
    double? initialLongitude;
    String? initialLocationName;

    if (currentState is LocationSaved) {
      initialLatitude = currentState.latitude;
      initialLongitude = currentState.longitude;
      initialLocationName = currentState.locationName;
    } else if (currentState is LocationLoaded) {
      initialLatitude = currentState.latitude;
      initialLongitude = currentState.longitude;
      initialLocationName = currentState.locationName;
    }

    final result = await context.push<Map<String, dynamic>>(
      '/map',
      extra: {
        'latitude': initialLatitude,
        'longitude': initialLongitude,
        'locationName': initialLocationName,
      },
    );

    if (result != null && result['latitude'] != null && result['longitude'] != null) {
      // تحديث الموقع
      locationBloc.add(SaveSelectedLocation(
        latitude: result['latitude'],
        longitude: result['longitude'],
        locationName: result['locationName'],
      ));

      // تحديث مساحات العمل القريبة بناءً على الموقع الجديد
      workspaceCubit.fetchNearbyWorkspaces(
        result['latitude'],
        result['longitude'],
      );

      print('Location updated to: ${result['locationName']}');
    }
  }}
String _getFirstTwoWords(String text) {
  final words = text.trim().split(' ');
  if (words.length <= 2) return text;
  return '${words[0]} ${words[1]}';
}
