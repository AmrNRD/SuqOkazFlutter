import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:suqokaz/bloc/user/user_event.dart';
import 'package:suqokaz/bloc/user/user_state.dart';
import 'package:suqokaz/data/models/user_model.dart';
import 'package:suqokaz/data/repositories/user_repository.dart';

import '../../main.dart';

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
      yield UserLoadingState();
      if (event is GetUser) {
        Root.user=await userRepository.fetchUserData();
        yield UserLoadedState();
      } else if (event is LoginUser) {
       Root.user=await userRepository.login({
          "username": event.email,
          "password": event.password,
        });
        yield UserLoadedState();
      }else if (event is SignUpUser) {
        Root.user=await userRepository.signUp(event.email, event.password, event.passwordConfirmation);
        yield UserLoadedState();
      } else if (event is LogoutUser) {
        await userRepository.logout();
          yield UserLoggedOutState();
    }
    } catch (error) {
      print(error.runtimeType);
      print(error.toString());
      yield UserErrorState(error.toString());
    }
  }
}
