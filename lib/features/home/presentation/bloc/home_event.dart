part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadHomeEvent extends HomeEvent {
  const LoadHomeEvent();
}

final class FilterHomeEvent extends HomeEvent {
  const FilterHomeEvent(this.activeFilter);

  final String activeFilter;

  @override
  List<Object?> get props => [activeFilter];
}

final class SearchHomeEvent extends HomeEvent {
  const SearchHomeEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class PickFileHomeEvent extends HomeEvent {
  const PickFileHomeEvent();
}
