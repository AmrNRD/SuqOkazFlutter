part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
}


class AddAddressEvent extends AddressEvent {
  final AddressModel addressModel;

  AddAddressEvent(this.addressModel);

  @override
  List<Object> get props => [this.addressModel];
}

class EditAddressEvent extends AddressEvent {
  final AddressModel addressModel;

  EditAddressEvent(this.addressModel);

  @override
  List<Object> get props => [this.addressModel];
}

class DeleteAddressEvent extends AddressEvent {
  final int id;

  DeleteAddressEvent(this.id);

  @override
  List<Object> get props => [this.id];
}


class GetAllAddressEvent extends AddressEvent {
  @override
  List<Object> get props => [];
}


class GetAddressByIdEvent extends AddressEvent {
  final int id;

  GetAddressByIdEvent(this.id);

  @override
  List<Object> get props => [this.id];
}
