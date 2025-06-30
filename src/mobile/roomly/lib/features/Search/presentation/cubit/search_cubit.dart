import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/entities/filter_params.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/usecases/search_usecase.dart';
import '../../domain/usecases/filter_rooms_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQuery extends SearchEvent {
  final String query;

  const SearchQuery(this.query);

  @override
  List<Object> get props => [query];
}

class FilterRooms extends SearchEvent {
  final FilterParams filterParams;

  const FilterRooms(this.filterParams);

  @override
  List<Object> get props => [filterParams];
}

class ClearSearch extends SearchEvent {}

// States
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResult searchResult;

  const SearchLoaded(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}

class FilterLoaded extends SearchState {
  final List<Room> filteredRooms;

  const FilterLoaded(this.filteredRooms);

  @override
  List<Object> get props => [filteredRooms];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationsLoading extends SearchState {}

class RecommendationsLoaded extends SearchState {
  final List<Recommendation> recommendations;

  const RecommendationsLoaded(this.recommendations);

  @override
  List<Object> get props => [recommendations];
}

class RecommendationsError extends SearchState {
  final String message;

  const RecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;
  final FilterRoomsUseCase filterRoomsUseCase;
  final GetRecommendationsUseCase getRecommendationsUseCase;

  List<Recommendation> _recommendations = [];
  List<Recommendation> get recommendations => _recommendations;

  SearchCubit({
    required this.searchUseCase,
    required this.filterRoomsUseCase,
    required this.getRecommendationsUseCase,
  }) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final searchResult = await searchUseCase(query);
      emit(SearchLoaded(searchResult));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> filterRooms(FilterParams filterParams) async {
    emit(SearchLoading());
    try {
      final filteredRooms = await filterRoomsUseCase(filterParams);
      emit(FilterLoaded(filteredRooms));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }

  Future<void> fetchRecommendations(String userId, {int topN = 5}) async {
    emit(RecommendationsLoading());
    try {
      final recs = await getRecommendationsUseCase(userId, topN: topN);
      _recommendations = recs;
      emit(RecommendationsLoaded(recs));
    } catch (e) {
      emit(RecommendationsError(e.toString()));
    }
  }
}
