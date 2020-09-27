part of 'coupon_bloc.dart';

@immutable
abstract class CouponEvent {}

class GetCoupon extends CouponEvent{
  final String code;
  GetCoupon(this.code);
}