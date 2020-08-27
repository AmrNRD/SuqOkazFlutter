import 'package:suqokaz/data/sources/local/local.database.dart';

import 'local.database.dart';

class AddressService {
  final AppDataBase appDataBase;

  AddressService(this.appDataBase);

  Future<List<AddressModel>> getAllAddress() {
    return appDataBase.getAllAddress();
  }

  Future<AddressModel> getAddressById(int id) {
    return appDataBase.getAddressById(id);
  }

  Future insertAddress(AddressModel addressData) {
    return appDataBase.insertAddress(addressData);
  }

  Future updateAddress(AddressModel addressData) {
    return appDataBase.updateAddress(addressData);
  }

  Future deleteAddress(int id) {
    return appDataBase.deleteAddress(id);
  }

}
