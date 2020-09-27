part of 'coupon_bloc.dart';

@immutable
abstract class CouponState {}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  final Coupon coupon;
  CouponLoaded(this.coupon);
}
class CouponError extends CouponState {
  final String error;
  CouponError(this.error);
}
