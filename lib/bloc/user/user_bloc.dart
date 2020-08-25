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
    if (event is GetUser) {
      yield UserLoading();
      try {
        final UserModel user = await userRepository.fetchUserData();
        yield UserLoaded(user);
      }   catch (error){
        yield UserError(error.toString());
      }
    }
  }


}
