import 'package:suqokaz/data/sources/local/address.service.local.dart';
import 'package:suqokaz/data/sources/local/cart.service.local.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

abstract class AddressRepository {
  Future<List<AddressModel>> fetchAddresses();
  Future createAddress(AddressModel addressData);
  Future updateAddress(AddressModel addressData);
  Future<AddressModel> getAddressItemById(int id);
  Future deleteAddress(int id);
}

class AddressDataRepository extends AddressRepository {
  AddressService _addressService;

  AddressDataRepository(AppDataBase appDataBase) {
    _addressService = AddressService(appDataBase);
  }

  @override
  Future createAddress(AddressModel addressData) async {
    return await _addressService.insertAddress(addressData);
  }

  @override
  Future deleteAddress(int id) async {
    return await _addressService.deleteAddress(id);
  }

  @override
  Future<List<AddressModel>> fetchAddresses() async {
    return await _addressService.getAllAddress();
  }

  @override
  Future<AddressModel> getAddressItemById(int id) async {
    return await _addressService.getAddressById(id);
  }

  @override
  Future updateAddress(AddressModel addressData) async {
    return await _addressService.updateAddress(addressData);
  }
}
