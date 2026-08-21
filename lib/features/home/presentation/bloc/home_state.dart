part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.allDesigns,
    required this.filteredDesigns,
    required this.activeFilter,
    required this.searchQuery,
    this.openedFilePath,
  });

  final List<EmbroideryDesign> allDesigns;
  final List<EmbroideryDesign> filteredDesigns;
  final String activeFilter;
  final String searchQuery;
  final String? openedFilePath;

  @override
  List<Object?> get props => [
        allDesigns,
        filteredDesigns,
        activeFilter,
        searchQuery,
        openedFilePath,
      ];

  HomeLoaded copyWith({
    List<EmbroideryDesign>? allDesigns,
    List<EmbroideryDesign>? filteredDesigns,
    String? activeFilter,
    String? searchQuery,
    String? openedFilePath,
  }) {
    return HomeLoaded(
      allDesigns: allDesigns ?? this.allDesigns,
      filteredDesigns: filteredDesigns ?? this.filteredDesigns,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      openedFilePath: openedFilePath ?? this.openedFilePath,
    );
  }
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
