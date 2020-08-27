import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/repositories/address.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

import '../../data/sources/local/local.database.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this._addressDataRepository) : super(AddressInitial());

  final AddressDataRepository _addressDataRepository;

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    try {
      yield AddressLoadingState();
      if (event is GetAllAddressEvent) {
        List<AddressModel> addresses =
            await _addressDataRepository.fetchAddresses();
        yield AddressesLoadedState(addresses);
      } else if (event is GetAddressByIdEvent) {
        AddressModel address =
            await _addressDataRepository.getAddressItemById(event.id);
        yield AddressLoadedState(address);
      } else if (event is AddAddressEvent) {
        await _addressDataRepository.createAddress(event.addressModel);
        yield AddressCreatedState();
      } else if (event is EditAddressEvent) {
        await _addressDataRepository.updateAddress(event.addressModel);
        yield AddressUpdatedState();
      } else if (event is DeleteAddressEvent) {
        await _addressDataRepository.deleteAddress(event.id);
        yield AddressDeletedState();
      }
    } catch (exception) {
      // Yield error with message, exception can't be casted to string in some cases
      try {
        yield AddressErrorState(exception.toString());
      } catch (_) {
        yield AddressErrorState("Error occurred"); // TODO: translate
      }
    }
  }
}
