import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../Search/presentation/screens/CustomSearchBottom.dart';
import '../../../Search/data/data_sources/search_remote_data_source.dart';
import '../../../Search/data/repositories/search_repository_impl.dart';
import '../../../Search/domain/usecases/search_usecase.dart';
import '../../../Search/domain/usecases/filter_rooms_usecase.dart';
import '../../../Search/presentation/cubit/search_cubit.dart';
import '../../../Search/data/data_sources/recommendation_remote_data_source.dart';
import '../../../Search/domain/usecases/get_recommendations_usecase.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomBottomSheet(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: const Color.fromARGB(127, 0, 0, 0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/magnifying-glass-solid.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(255, 255, 255, 127),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'Search Workspaces',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 127),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (context) {
            final dio = Dio();
            final remoteDataSource = SearchRemoteDataSourceImpl(dio: dio);
            final recommendationRemoteDataSource =
                RecommendationRemoteDataSource();
            final repository = SearchRepositoryImpl(
              remoteDataSource: remoteDataSource,
              recommendationRemoteDataSource: recommendationRemoteDataSource,
            );
            return SearchCubit(
              searchUseCase: SearchUseCase(repository: repository),
              filterRoomsUseCase: FilterRoomsUseCase(repository: repository),
              getRecommendationsUseCase: GetRecommendationsUseCase(repository),
            );
          },
          child: const CustomSearchBottomSheet(),
        );
      },
    );
  }
}
