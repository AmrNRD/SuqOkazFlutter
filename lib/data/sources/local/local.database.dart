import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'local.database.g.dart';

class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get image => text()();
  IntColumn get parent => integer()();
  IntColumn get menuOrder => integer()();
  IntColumn get totalProduct => integer()();
}

class Cart extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get addressId =>
      integer().nullable().customConstraint("REFERENCES address(id)")();
  TextColumn get shippingMethodId => text().nullable()();
  TextColumn get discountCoupon => text().nullable()();
}

class CartItems extends Table {
  IntColumn get id => integer()();
  IntColumn get cartId => integer().customConstraint("REFERENCES cart(id)")();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Address extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address1 => text()();
  TextColumn get address2 => text()();
  TextColumn get company => text()();
  TextColumn get city => text()();
  TextColumn get postCode => text()();
  TextColumn get country => text().withDefault(const Constant("EG"))();
}

@UseMoor(tables: [
  Category,
  Cart,
  CartItems,
  Address,
])
class AppDataBase extends _$AppDataBase {
  // we tell the database where to store the data with this constructor
  AppDataBase() : super(_openConnection());

  static FlutterQueryExecutor _openConnection() {
    return FlutterQueryExecutor.inDatabaseFolder(
        path: "db.ralph", logStatements: true);
  }

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 4) {
          // m.deleteTable("unit");
          // m.createTable(unit);
        }
      }, beforeOpen: (details) async {
        if (details.wasCreated) {
          //If you want to add seeders to the DB
        }
      });

  // Category CRUD
  Stream<List<CategoryData>> watchAllCategories() => select(category).watch();
  Future<List<CategoryData>> getAllCategories() => select(category).get();
  Future<List<CategoryData>> getAllParentCategories() => (select(category)
        ..where(
          (c) => c.parent.equals(0),
        ))
      .get();
  Future<List<CategoryData>> getCategoriesById(int id) => (select(category)
        ..where(
          (c) => c.id.equals(id),
        ))
      .get();
  Future insertCategory(CategoryData categoryData) =>
      into(category).insert(categoryData);
  Future updateCategory(CategoryData categoryData) =>
      update(category).replace(categoryData);
  Future deleteCategory(int id) => (delete(category)
        ..where(
          (c) => c.id.equals(id),
        ))
      .go();

  //Cart CRUD
  Future<CartData> getCart() => select(cart).getSingle();
  Future insertCart(CartData cartData) => into(cart).insert(cartData);
  Future updateCart(CartData cartData) => update(cart).replace(cartData);
  Future deleteCart(int id) => (delete(cart)
        ..where(
          (c) => c.id.equals(id),
        ))
      .go();

  // CartItems CRUD
  Stream<List<CartItem>> watchAllCartItems() => select(cartItems).watch();
  Future<List<CartItem>> getAllCartItems(int cartId) => (select(cartItems)
        ..where(
          (c) => c.cartId.equals(cartId),
        ))
      .get();

  Future<int> countAllCartItems(int cartId) async {
    List<CartItem> cartItems = await getAllCartItems(cartId);
    int totalQuant = 0;
    await Future.forEach(cartItems, (CartItem cartItem) async {
      totalQuant += cartItem.quantity;
    });
    return totalQuant;
  }

  Future<CartItem> getCartItemById(int id) => (select(cartItems)
        ..where(
          (c) => c.id.equals(id),
        ))
      .getSingle();
  Future insertCartItem(CartItem cartItemData) =>
      into(cartItems).insert(cartItemData);
  Future updateCartItem(CartItem cartItemData) =>
      update(cartItems).replace(cartItemData);
  Future deleteCartItem(int id) => (delete(cartItems)
        ..where(
          (c) => c.id.equals(id),
        ))
      .go();

  // Address CRUD
  Stream<List<AddressModel>> watchAllAddress() => select(address).watch();
  Future<List<AddressModel>> getAllAddress() => select(address).get();

  Future<AddressModel> getAddressById(int id) => (select(address)
        ..where(
          (c) => c.id.equals(id),
        ))
      .getSingle();
  Future insertAddress(AddressModel addressData) =>
      into(address).insert(addressData);
  Future updateAddress(AddressModel addressData) =>
      update(address).replace(addressData);
  Future deleteAddress(int id) => (delete(address)
        ..where(
          (c) => c.id.equals(id),
        ))
      .go();
}
