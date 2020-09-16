// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final String image;
  final int parent;
  final int menuOrder;
  final int totalProduct;
  bool sorted = false;
  List<dynamic> children = [];
  CategoryData(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.parent,
      @required this.menuOrder,
      @required this.totalProduct});
  factory CategoryData.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CategoryData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      image: stringType.mapFromDatabaseResponse(data['${effectivePrefix}image']),
      parent: intType.mapFromDatabaseResponse(data['${effectivePrefix}parent']),
      menuOrder: intType.mapFromDatabaseResponse(data['${effectivePrefix}menu_order']),
      totalProduct: intType.mapFromDatabaseResponse(data['${effectivePrefix}total_product']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<int>(parent);
    }
    if (!nullToAbsent || menuOrder != null) {
      map['menu_order'] = Variable<int>(menuOrder);
    }
    if (!nullToAbsent || totalProduct != null) {
      map['total_product'] = Variable<int>(totalProduct);
    }
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      image: image == null && nullToAbsent ? const Value.absent() : Value(image),
      parent: parent == null && nullToAbsent ? const Value.absent() : Value(parent),
      menuOrder: menuOrder == null && nullToAbsent ? const Value.absent() : Value(menuOrder),
      totalProduct: totalProduct == null && nullToAbsent ? const Value.absent() : Value(totalProduct),
    );
  }

  factory CategoryData.fromJson(Map<String, dynamic> json, {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      image: serializer.fromJson<String>(json['image']),
      parent: serializer.fromJson<int>(json['parent']),
      menuOrder: serializer.fromJson<int>(json['menuOrder']),
      totalProduct: serializer.fromJson<int>(json['totalProduct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'image': serializer.toJson<String>(image),
      'parent': serializer.toJson<int>(parent),
      'menuOrder': serializer.toJson<int>(menuOrder),
      'totalProduct': serializer.toJson<int>(totalProduct),
    };
  }

  CategoryData copyWith({int id, String name, String image, int parent, int menuOrder, int totalProduct}) =>
      CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        parent: parent ?? this.parent,
        menuOrder: menuOrder ?? this.menuOrder,
        totalProduct: totalProduct ?? this.totalProduct,
      );
  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('parent: $parent, ')
          ..write('menuOrder: $menuOrder, ')
          ..write('totalProduct: $totalProduct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(name.hashCode,
          $mrjc(image.hashCode, $mrjc(parent.hashCode, $mrjc(menuOrder.hashCode, totalProduct.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.image == this.image &&
          other.parent == this.parent &&
          other.menuOrder == this.menuOrder &&
          other.totalProduct == this.totalProduct);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> image;
  final Value<int> parent;
  final Value<int> menuOrder;
  final Value<int> totalProduct;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.image = const Value.absent(),
    this.parent = const Value.absent(),
    this.menuOrder = const Value.absent(),
    this.totalProduct = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String image,
    @required int parent,
    @required int menuOrder,
    @required int totalProduct,
  })  : name = Value(name),
        image = Value(image),
        parent = Value(parent),
        menuOrder = Value(menuOrder),
        totalProduct = Value(totalProduct);
  static Insertable<CategoryData> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> image,
    Expression<int> parent,
    Expression<int> menuOrder,
    Expression<int> totalProduct,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (parent != null) 'parent': parent,
      if (menuOrder != null) 'menu_order': menuOrder,
      if (totalProduct != null) 'total_product': totalProduct,
    });
  }

  CategoryCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> image,
      Value<int> parent,
      Value<int> menuOrder,
      Value<int> totalProduct}) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      parent: parent ?? this.parent,
      menuOrder: menuOrder ?? this.menuOrder,
      totalProduct: totalProduct ?? this.totalProduct,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (parent.present) {
      map['parent'] = Variable<int>(parent.value);
    }
    if (menuOrder.present) {
      map['menu_order'] = Variable<int>(menuOrder.value);
    }
    if (totalProduct.present) {
      map['total_product'] = Variable<int>(totalProduct.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('image: $image, ')
          ..write('parent: $parent, ')
          ..write('menuOrder: $menuOrder, ')
          ..write('totalProduct: $totalProduct')
          ..write(')'))
        .toString();
  }
}

class $CategoryTable extends Category with TableInfo<$CategoryTable, CategoryData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CategoryTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedTextColumn _image;
  @override
  GeneratedTextColumn get image => _image ??= _constructImage();
  GeneratedTextColumn _constructImage() {
    return GeneratedTextColumn(
      'image',
      $tableName,
      false,
    );
  }

  final VerificationMeta _parentMeta = const VerificationMeta('parent');
  GeneratedIntColumn _parent;
  @override
  GeneratedIntColumn get parent => _parent ??= _constructParent();
  GeneratedIntColumn _constructParent() {
    return GeneratedIntColumn(
      'parent',
      $tableName,
      false,
    );
  }

  final VerificationMeta _menuOrderMeta = const VerificationMeta('menuOrder');
  GeneratedIntColumn _menuOrder;
  @override
  GeneratedIntColumn get menuOrder => _menuOrder ??= _constructMenuOrder();
  GeneratedIntColumn _constructMenuOrder() {
    return GeneratedIntColumn(
      'menu_order',
      $tableName,
      false,
    );
  }

  final VerificationMeta _totalProductMeta = const VerificationMeta('totalProduct');
  GeneratedIntColumn _totalProduct;
  @override
  GeneratedIntColumn get totalProduct => _totalProduct ??= _constructTotalProduct();
  GeneratedIntColumn _constructTotalProduct() {
    return GeneratedIntColumn(
      'total_product',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, image, parent, menuOrder, totalProduct];
  @override
  $CategoryTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'category';
  @override
  final String actualTableName = 'category';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image')) {
      context.handle(_imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta, parent.isAcceptableOrUnknown(data['parent'], _parentMeta));
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    if (data.containsKey('menu_order')) {
      context.handle(_menuOrderMeta, menuOrder.isAcceptableOrUnknown(data['menu_order'], _menuOrderMeta));
    } else if (isInserting) {
      context.missing(_menuOrderMeta);
    }
    if (data.containsKey('total_product')) {
      context.handle(_totalProductMeta, totalProduct.isAcceptableOrUnknown(data['total_product'], _totalProductMeta));
    } else if (isInserting) {
      context.missing(_totalProductMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CategoryData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(_db, alias);
  }
}

class CartData extends DataClass implements Insertable<CartData> {
  final int id;
  final int addressId;
  final String shippingMethodId;
  final String discountCoupon;
  CartData({@required this.id, this.addressId, this.shippingMethodId, this.discountCoupon});
  factory CartData.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return CartData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      addressId: intType.mapFromDatabaseResponse(data['${effectivePrefix}address_id']),
      shippingMethodId: stringType.mapFromDatabaseResponse(data['${effectivePrefix}shipping_method_id']),
      discountCoupon: stringType.mapFromDatabaseResponse(data['${effectivePrefix}discount_coupon']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || addressId != null) {
      map['address_id'] = Variable<int>(addressId);
    }
    if (!nullToAbsent || shippingMethodId != null) {
      map['shipping_method_id'] = Variable<String>(shippingMethodId);
    }
    if (!nullToAbsent || discountCoupon != null) {
      map['discount_coupon'] = Variable<String>(discountCoupon);
    }
    return map;
  }

  CartCompanion toCompanion(bool nullToAbsent) {
    return CartCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      addressId: addressId == null && nullToAbsent ? const Value.absent() : Value(addressId),
      shippingMethodId: shippingMethodId == null && nullToAbsent ? const Value.absent() : Value(shippingMethodId),
      discountCoupon: discountCoupon == null && nullToAbsent ? const Value.absent() : Value(discountCoupon),
    );
  }

  factory CartData.fromJson(Map<String, dynamic> json, {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartData(
      id: serializer.fromJson<int>(json['id']),
      addressId: serializer.fromJson<int>(json['addressId']),
      shippingMethodId: serializer.fromJson<String>(json['shippingMethodId']),
      discountCoupon: serializer.fromJson<String>(json['discountCoupon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'addressId': serializer.toJson<int>(addressId),
      'shippingMethodId': serializer.toJson<String>(shippingMethodId),
      'discountCoupon': serializer.toJson<String>(discountCoupon),
    };
  }

  CartData copyWith({int id, int addressId, String shippingMethodId, String discountCoupon}) => CartData(
        id: id ?? this.id,
        addressId: addressId ?? this.addressId,
        shippingMethodId: shippingMethodId ?? this.shippingMethodId,
        discountCoupon: discountCoupon ?? this.discountCoupon,
      );
  @override
  String toString() {
    return (StringBuffer('CartData(')
          ..write('id: $id, ')
          ..write('addressId: $addressId, ')
          ..write('shippingMethodId: $shippingMethodId, ')
          ..write('discountCoupon: $discountCoupon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(addressId.hashCode, $mrjc(shippingMethodId.hashCode, discountCoupon.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CartData &&
          other.id == this.id &&
          other.addressId == this.addressId &&
          other.shippingMethodId == this.shippingMethodId &&
          other.discountCoupon == this.discountCoupon);
}

class CartCompanion extends UpdateCompanion<CartData> {
  final Value<int> id;
  final Value<int> addressId;
  final Value<String> shippingMethodId;
  final Value<String> discountCoupon;
  const CartCompanion({
    this.id = const Value.absent(),
    this.addressId = const Value.absent(),
    this.shippingMethodId = const Value.absent(),
    this.discountCoupon = const Value.absent(),
  });
  CartCompanion.insert({
    this.id = const Value.absent(),
    this.addressId = const Value.absent(),
    this.shippingMethodId = const Value.absent(),
    this.discountCoupon = const Value.absent(),
  });
  static Insertable<CartData> custom({
    Expression<int> id,
    Expression<int> addressId,
    Expression<String> shippingMethodId,
    Expression<String> discountCoupon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (addressId != null) 'address_id': addressId,
      if (shippingMethodId != null) 'shipping_method_id': shippingMethodId,
      if (discountCoupon != null) 'discount_coupon': discountCoupon,
    });
  }

  CartCompanion copyWith(
      {Value<int> id, Value<int> addressId, Value<String> shippingMethodId, Value<String> discountCoupon}) {
    return CartCompanion(
      id: id ?? this.id,
      addressId: addressId ?? this.addressId,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      discountCoupon: discountCoupon ?? this.discountCoupon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (addressId.present) {
      map['address_id'] = Variable<int>(addressId.value);
    }
    if (shippingMethodId.present) {
      map['shipping_method_id'] = Variable<String>(shippingMethodId.value);
    }
    if (discountCoupon.present) {
      map['discount_coupon'] = Variable<String>(discountCoupon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartCompanion(')
          ..write('id: $id, ')
          ..write('addressId: $addressId, ')
          ..write('shippingMethodId: $shippingMethodId, ')
          ..write('discountCoupon: $discountCoupon')
          ..write(')'))
        .toString();
  }
}

class $CartTable extends Cart with TableInfo<$CartTable, CartData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CartTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false, hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _addressIdMeta = const VerificationMeta('addressId');
  GeneratedIntColumn _addressId;
  @override
  GeneratedIntColumn get addressId => _addressId ??= _constructAddressId();
  GeneratedIntColumn _constructAddressId() {
    return GeneratedIntColumn('address_id', $tableName, true, $customConstraints: 'REFERENCES address(id)');
  }

  final VerificationMeta _shippingMethodIdMeta = const VerificationMeta('shippingMethodId');
  GeneratedTextColumn _shippingMethodId;
  @override
  GeneratedTextColumn get shippingMethodId => _shippingMethodId ??= _constructShippingMethodId();
  GeneratedTextColumn _constructShippingMethodId() {
    return GeneratedTextColumn(
      'shipping_method_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _discountCouponMeta = const VerificationMeta('discountCoupon');
  GeneratedTextColumn _discountCoupon;
  @override
  GeneratedTextColumn get discountCoupon => _discountCoupon ??= _constructDiscountCoupon();
  GeneratedTextColumn _constructDiscountCoupon() {
    return GeneratedTextColumn(
      'discount_coupon',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, addressId, shippingMethodId, discountCoupon];
  @override
  $CartTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cart';
  @override
  final String actualTableName = 'cart';
  @override
  VerificationContext validateIntegrity(Insertable<CartData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('address_id')) {
      context.handle(_addressIdMeta, addressId.isAcceptableOrUnknown(data['address_id'], _addressIdMeta));
    }
    if (data.containsKey('shipping_method_id')) {
      context.handle(_shippingMethodIdMeta,
          shippingMethodId.isAcceptableOrUnknown(data['shipping_method_id'], _shippingMethodIdMeta));
    }
    if (data.containsKey('discount_coupon')) {
      context.handle(
          _discountCouponMeta, discountCoupon.isAcceptableOrUnknown(data['discount_coupon'], _discountCouponMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CartData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CartTable createAlias(String alias) {
    return $CartTable(_db, alias);
  }
}

class CartItem extends DataClass implements Insertable<CartItem> {
  final int id;
  final int variationId;
  final int cartId;
  final int quantity;
  CartItem({@required this.id, this.variationId, @required this.cartId, @required this.quantity});
  factory CartItem.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return CartItem(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      variationId: intType.mapFromDatabaseResponse(data['${effectivePrefix}variation_id']),
      cartId: intType.mapFromDatabaseResponse(data['${effectivePrefix}cart_id']),
      quantity: intType.mapFromDatabaseResponse(data['${effectivePrefix}quantity']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || variationId != null) {
      map['variation_id'] = Variable<int>(variationId);
    }
    if (!nullToAbsent || cartId != null) {
      map['cart_id'] = Variable<int>(cartId);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<int>(quantity);
    }
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      variationId: variationId == null && nullToAbsent ? const Value.absent() : Value(variationId),
      cartId: cartId == null && nullToAbsent ? const Value.absent() : Value(cartId),
      quantity: quantity == null && nullToAbsent ? const Value.absent() : Value(quantity),
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json, {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CartItem(
      id: serializer.fromJson<int>(json['id']),
      variationId: serializer.fromJson<int>(json['variationId']),
      cartId: serializer.fromJson<int>(json['cartId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'variationId': serializer.toJson<int>(variationId),
      'cartId': serializer.toJson<int>(cartId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartItem copyWith({int id, int variationId, int cartId, int quantity}) => CartItem(
        id: id ?? this.id,
        variationId: variationId ?? this.variationId,
        cartId: cartId ?? this.cartId,
        quantity: quantity ?? this.quantity,
      );
  @override
  String toString() {
    return (StringBuffer('CartItem(')
          ..write('id: $id, ')
          ..write('variationId: $variationId, ')
          ..write('cartId: $cartId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, $mrjc(variationId.hashCode, $mrjc(cartId.hashCode, quantity.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == this.id &&
          other.variationId == this.variationId &&
          other.cartId == this.cartId &&
          other.quantity == this.quantity);
}

class CartItemsCompanion extends UpdateCompanion<CartItem> {
  final Value<int> id;
  final Value<int> variationId;
  final Value<int> cartId;
  final Value<int> quantity;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.variationId = const Value.absent(),
    this.cartId = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  CartItemsCompanion.insert({
    @required int id,
    this.variationId = const Value.absent(),
    @required int cartId,
    @required int quantity,
  })  : id = Value(id),
        cartId = Value(cartId),
        quantity = Value(quantity);
  static Insertable<CartItem> custom({
    Expression<int> id,
    Expression<int> variationId,
    Expression<int> cartId,
    Expression<int> quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variationId != null) 'variation_id': variationId,
      if (cartId != null) 'cart_id': cartId,
      if (quantity != null) 'quantity': quantity,
    });
  }

  CartItemsCompanion copyWith({Value<int> id, Value<int> variationId, Value<int> cartId, Value<int> quantity}) {
    return CartItemsCompanion(
      id: id ?? this.id,
      variationId: variationId ?? this.variationId,
      cartId: cartId ?? this.cartId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (variationId.present) {
      map['variation_id'] = Variable<int>(variationId.value);
    }
    if (cartId.present) {
      map['cart_id'] = Variable<int>(cartId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('variationId: $variationId, ')
          ..write('cartId: $cartId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems with TableInfo<$CartItemsTable, CartItem> {
  final GeneratedDatabase _db;
  final String _alias;
  $CartItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _variationIdMeta = const VerificationMeta('variationId');
  GeneratedIntColumn _variationId;
  @override
  GeneratedIntColumn get variationId => _variationId ??= _constructVariationId();
  GeneratedIntColumn _constructVariationId() {
    return GeneratedIntColumn(
      'variation_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  GeneratedIntColumn _cartId;
  @override
  GeneratedIntColumn get cartId => _cartId ??= _constructCartId();
  GeneratedIntColumn _constructCartId() {
    return GeneratedIntColumn('cart_id', $tableName, false, $customConstraints: 'REFERENCES cart(id)');
  }

  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  GeneratedIntColumn _quantity;
  @override
  GeneratedIntColumn get quantity => _quantity ??= _constructQuantity();
  GeneratedIntColumn _constructQuantity() {
    return GeneratedIntColumn(
      'quantity',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, variationId, cartId, quantity];
  @override
  $CartItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'cart_items';
  @override
  final String actualTableName = 'cart_items';
  @override
  VerificationContext validateIntegrity(Insertable<CartItem> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('variation_id')) {
      context.handle(_variationIdMeta, variationId.isAcceptableOrUnknown(data['variation_id'], _variationIdMeta));
    }
    if (data.containsKey('cart_id')) {
      context.handle(_cartIdMeta, cartId.isAcceptableOrUnknown(data['cart_id'], _cartIdMeta));
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta, quantity.isAcceptableOrUnknown(data['quantity'], _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  CartItem map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CartItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(_db, alias);
  }
}

class AddressModel extends DataClass implements Insertable<AddressModel> {
  final int id;
  final String address1;
  final String address2;
  final String company;
  final String city;
  final String postCode;
  final String country;
  AddressModel(
      {@required this.id,
      @required this.address1,
      @required this.address2,
      @required this.company,
      @required this.city,
      @required this.postCode,
      @required this.country});
  factory AddressModel.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return AddressModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      address1: stringType.mapFromDatabaseResponse(data['${effectivePrefix}address1']),
      address2: stringType.mapFromDatabaseResponse(data['${effectivePrefix}address2']),
      company: stringType.mapFromDatabaseResponse(data['${effectivePrefix}company']),
      city: stringType.mapFromDatabaseResponse(data['${effectivePrefix}city']),
      postCode: stringType.mapFromDatabaseResponse(data['${effectivePrefix}post_code']),
      country: stringType.mapFromDatabaseResponse(data['${effectivePrefix}country']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || address1 != null) {
      map['address1'] = Variable<String>(address1);
    }
    if (!nullToAbsent || address2 != null) {
      map['address2'] = Variable<String>(address2);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || postCode != null) {
      map['post_code'] = Variable<String>(postCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    return map;
  }

  AddressCompanion toCompanion(bool nullToAbsent) {
    return AddressCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      address1: address1 == null && nullToAbsent ? const Value.absent() : Value(address1),
      address2: address2 == null && nullToAbsent ? const Value.absent() : Value(address2),
      company: company == null && nullToAbsent ? const Value.absent() : Value(company),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      postCode: postCode == null && nullToAbsent ? const Value.absent() : Value(postCode),
      country: country == null && nullToAbsent ? const Value.absent() : Value(country),
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json, {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AddressModel(
      id: serializer.fromJson<int>(json['id']),
      address1: serializer.fromJson<String>(json['address1']),
      address2: serializer.fromJson<String>(json['address2']),
      company: serializer.fromJson<String>(json['company']),
      city: serializer.fromJson<String>(json['city']),
      postCode: serializer.fromJson<String>(json['postCode']),
      country: serializer.fromJson<String>(json['country']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address1': serializer.toJson<String>(address1),
      'address2': serializer.toJson<String>(address2),
      'company': serializer.toJson<String>(company),
      'city': serializer.toJson<String>(city),
      'postCode': serializer.toJson<String>(postCode),
      'country': serializer.toJson<String>(country),
    };
  }

  AddressModel copyWith(
          {int id, String address1, String address2, String company, String city, String postCode, String country}) =>
      AddressModel(
        id: id ?? this.id,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        company: company ?? this.company,
        city: city ?? this.city,
        postCode: postCode ?? this.postCode,
        country: country ?? this.country,
      );
  @override
  String toString() {
    return (StringBuffer('AddressModel(')
          ..write('id: $id, ')
          ..write('address1: $address1, ')
          ..write('address2: $address2, ')
          ..write('company: $company, ')
          ..write('city: $city, ')
          ..write('postCode: $postCode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          address1.hashCode,
          $mrjc(address2.hashCode,
              $mrjc(company.hashCode, $mrjc(city.hashCode, $mrjc(postCode.hashCode, country.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AddressModel &&
          other.id == this.id &&
          other.address1 == this.address1 &&
          other.address2 == this.address2 &&
          other.company == this.company &&
          other.city == this.city &&
          other.postCode == this.postCode &&
          other.country == this.country);
}

class AddressCompanion extends UpdateCompanion<AddressModel> {
  final Value<int> id;
  final Value<String> address1;
  final Value<String> address2;
  final Value<String> company;
  final Value<String> city;
  final Value<String> postCode;
  final Value<String> country;
  const AddressCompanion({
    this.id = const Value.absent(),
    this.address1 = const Value.absent(),
    this.address2 = const Value.absent(),
    this.company = const Value.absent(),
    this.city = const Value.absent(),
    this.postCode = const Value.absent(),
    this.country = const Value.absent(),
  });
  AddressCompanion.insert({
    this.id = const Value.absent(),
    @required String address1,
    @required String address2,
    @required String company,
    @required String city,
    @required String postCode,
    this.country = const Value.absent(),
  })  : address1 = Value(address1),
        address2 = Value(address2),
        company = Value(company),
        city = Value(city),
        postCode = Value(postCode);
  static Insertable<AddressModel> custom({
    Expression<int> id,
    Expression<String> address1,
    Expression<String> address2,
    Expression<String> company,
    Expression<String> city,
    Expression<String> postCode,
    Expression<String> country,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address1 != null) 'address1': address1,
      if (address2 != null) 'address2': address2,
      if (company != null) 'company': company,
      if (city != null) 'city': city,
      if (postCode != null) 'post_code': postCode,
      if (country != null) 'country': country,
    });
  }

  AddressCompanion copyWith(
      {Value<int> id,
      Value<String> address1,
      Value<String> address2,
      Value<String> company,
      Value<String> city,
      Value<String> postCode,
      Value<String> country}) {
    return AddressCompanion(
      id: id ?? this.id,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      company: company ?? this.company,
      city: city ?? this.city,
      postCode: postCode ?? this.postCode,
      country: country ?? this.country,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (address1.present) {
      map['address1'] = Variable<String>(address1.value);
    }
    if (address2.present) {
      map['address2'] = Variable<String>(address2.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (postCode.present) {
      map['post_code'] = Variable<String>(postCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressCompanion(')
          ..write('id: $id, ')
          ..write('address1: $address1, ')
          ..write('address2: $address2, ')
          ..write('company: $company, ')
          ..write('city: $city, ')
          ..write('postCode: $postCode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }
}

class $AddressTable extends Address with TableInfo<$AddressTable, AddressModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $AddressTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false, hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _address1Meta = const VerificationMeta('address1');
  GeneratedTextColumn _address1;
  @override
  GeneratedTextColumn get address1 => _address1 ??= _constructAddress1();
  GeneratedTextColumn _constructAddress1() {
    return GeneratedTextColumn(
      'address1',
      $tableName,
      false,
    );
  }

  final VerificationMeta _address2Meta = const VerificationMeta('address2');
  GeneratedTextColumn _address2;
  @override
  GeneratedTextColumn get address2 => _address2 ??= _constructAddress2();
  GeneratedTextColumn _constructAddress2() {
    return GeneratedTextColumn(
      'address2',
      $tableName,
      false,
    );
  }

  final VerificationMeta _companyMeta = const VerificationMeta('company');
  GeneratedTextColumn _company;
  @override
  GeneratedTextColumn get company => _company ??= _constructCompany();
  GeneratedTextColumn _constructCompany() {
    return GeneratedTextColumn(
      'company',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cityMeta = const VerificationMeta('city');
  GeneratedTextColumn _city;
  @override
  GeneratedTextColumn get city => _city ??= _constructCity();
  GeneratedTextColumn _constructCity() {
    return GeneratedTextColumn(
      'city',
      $tableName,
      false,
    );
  }

  final VerificationMeta _postCodeMeta = const VerificationMeta('postCode');
  GeneratedTextColumn _postCode;
  @override
  GeneratedTextColumn get postCode => _postCode ??= _constructPostCode();
  GeneratedTextColumn _constructPostCode() {
    return GeneratedTextColumn(
      'post_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _countryMeta = const VerificationMeta('country');
  GeneratedTextColumn _country;
  @override
  GeneratedTextColumn get country => _country ??= _constructCountry();
  GeneratedTextColumn _constructCountry() {
    return GeneratedTextColumn('country', $tableName, false, defaultValue: const Constant("EG"));
  }

  @override
  List<GeneratedColumn> get $columns => [id, address1, address2, company, city, postCode, country];
  @override
  $AddressTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'address';
  @override
  final String actualTableName = 'address';
  @override
  VerificationContext validateIntegrity(Insertable<AddressModel> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('address1')) {
      context.handle(_address1Meta, address1.isAcceptableOrUnknown(data['address1'], _address1Meta));
    } else if (isInserting) {
      context.missing(_address1Meta);
    }
    if (data.containsKey('address2')) {
      context.handle(_address2Meta, address2.isAcceptableOrUnknown(data['address2'], _address2Meta));
    } else if (isInserting) {
      context.missing(_address2Meta);
    }
    if (data.containsKey('company')) {
      context.handle(_companyMeta, company.isAcceptableOrUnknown(data['company'], _companyMeta));
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('city')) {
      context.handle(_cityMeta, city.isAcceptableOrUnknown(data['city'], _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('post_code')) {
      context.handle(_postCodeMeta, postCode.isAcceptableOrUnknown(data['post_code'], _postCodeMeta));
    } else if (isInserting) {
      context.missing(_postCodeMeta);
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta, country.isAcceptableOrUnknown(data['country'], _countryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AddressModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AddressModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $AddressTable createAlias(String alias) {
    return $AddressTable(_db, alias);
  }
}

abstract class _$AppDataBase extends GeneratedDatabase {
  _$AppDataBase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CategoryTable _category;
  $CategoryTable get category => _category ??= $CategoryTable(this);
  $CartTable _cart;
  $CartTable get cart => _cart ??= $CartTable(this);
  $CartItemsTable _cartItems;
  $CartItemsTable get cartItems => _cartItems ??= $CartItemsTable(this);
  $AddressTable _address;
  $AddressTable get address => _address ??= $AddressTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [category, cart, cartItems, address];
}
