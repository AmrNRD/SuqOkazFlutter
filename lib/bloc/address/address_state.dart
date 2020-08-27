part of 'address_bloc.dart';

abstract class AddressState {
  const AddressState();
}

class AddressInitial extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressesLoadedState extends AddressState {
  final List<AddressModel> addresses;

  AddressesLoadedState(this.addresses);
}

class AddressLoadedState extends AddressState {
  final AddressModel address;

  AddressLoadedState(this.address);
}

class AddressCreatedState extends AddressState {}
class AddressUpdatedState extends AddressState {}
class AddressDeletedState extends AddressState {}



class AddressErrorState extends AddressState {
  final String message;

  AddressErrorState(this.message);
}

