import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_task/data/repository/repository_impl.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Repository _repository;
  HomeBloc(this._repository) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
