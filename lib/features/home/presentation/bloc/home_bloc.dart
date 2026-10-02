import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maa_design_stitch_viewer/app/models/models.dart';
import 'package:maa_design_stitch_viewer/features/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
    on<FilterHomeEvent>(_onFilter);
    on<SearchHomeEvent>(_onSearch);
    on<PickFileHomeEvent>(_onPickFile);
  }

  final HomeRepository repository;

  Future<void> _onLoad(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final designs = await repository.getSampleAndRecentDesigns();
      emit(HomeLoaded(
        allDesigns: designs,
        filteredDesigns: designs,
        activeFilter: 'ALL',
        searchQuery: '',
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onFilter(
    FilterHomeEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final filtered = _applyFilterAndSearch(
        current.allDesigns,
        event.activeFilter,
        current.searchQuery,
      );

      emit(current.copyWith(
        activeFilter: event.activeFilter,
        filteredDesigns: filtered,
        openedFilePath: null,
      ));
    }
  }

  void _onSearch(
    SearchHomeEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final filtered = _applyFilterAndSearch(
        current.allDesigns,
        current.activeFilter,
        event.query,
      );

      emit(current.copyWith(
        searchQuery: event.query,
        filteredDesigns: filtered,
        openedFilePath: null,
      ));
    }
  }

  Future<void> _onPickFile(
    PickFileHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      try {
        final path = await repository.pickEmbroideryFile();
        if (path != null) {
          final newDesign = await repository.parseDesignFile(path);
          final updatedList = [newDesign, ...current.allDesigns];
          final filtered = _applyFilterAndSearch(
            updatedList,
            current.activeFilter,
            current.searchQuery,
          );

          emit(current.copyWith(
            allDesigns: updatedList,
            filteredDesigns: filtered,
            openedFilePath: path,
          ));
        }
      } catch (e) {
        emit(HomeError('Failed to open file: $e'));
      }
    }
  }

  List<EmbroideryDesign> _applyFilterAndSearch(
    List<EmbroideryDesign> designs,
    String filter,
    String query,
  ) {
    return designs.where((d) {
      final matchesFilter =
          filter == 'ALL' || d.extension.toUpperCase() == filter.toUpperCase();
      final matchesQuery = query.isEmpty ||
          d.fileName.toLowerCase().contains(query.toLowerCase()) ||
          d.extension.toLowerCase().contains(query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();
  }
}
