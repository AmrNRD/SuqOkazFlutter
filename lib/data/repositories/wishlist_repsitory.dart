import 'package:suqokaz/data/sources/local/local.database.dart';

abstract class WishlistRepository {
  Future getWishlist();
  Future removeWishlistItem(int productId, int varId);
  Future addWishlistItem(int productId, int varId);
}

class WishlistDataRepository extends WishlistRepository {
  AppDataBase _appDataBas;
  WishlistDataRepository(AppDataBase _appDataBas) {
    this._appDataBas = _appDataBas;
  }

  @override
  Future<List<WishlistItem>> getWishlist() {
    return _appDataBas.getAllWishListItems();
  }

  @override
  Future addWishlistItem(int productId, int varId) {
    return _appDataBas.insertWishlistItem(
      WishlistItem(productId: productId, variationId: varId),
    );
  }

  @override
  Future removeWishlistItem(int productId, int varId) {
    return _appDataBas.deleteWishlistItem(
      productId,
      varId,
    );
  }
}
