import 'dart:io';

import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/sources/remote/coupon.service.dart';

abstract class CouponRepository {
  Future<Coupon> checkCoupon(String code);
}

class CouponDataRepository extends CouponRepository {
  CouponService _couponService;

  CouponDataRepository() {
    _couponService = CouponService();
  }

  @override
  Future<Coupon> checkCoupon(String code) async {
    var res = await _couponService.checkCoupon(code);
    if(res.length==0)
      throw HttpException("Does not exist");
    Coupon item = Coupon.fromJson(res[0]);
    return item;
  }
}
