import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:suqokaz/bloc/user/user_event.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/data/repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(null);

  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    try {
      if (event is GetUser) {
        yield UserLoadingState();

        await userRepository.fetchUserData();
        yield UserLoadedState();
      } else if (event is LoginUser) {
        await userRepository.login({
          "username": event.email,
          "password": event.password,
        });
        yield UserLoadedState();
      }
    } catch (error) {
      print(error.runtimeType);
      print(error.toString());
      yield UserErrorState(error.toString());
    }
  }
}
