import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/repositories/coupon.repository.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc(this.couponRepository) : super(CouponInitial());
  final CouponRepository couponRepository;
  @override
  Stream<CouponState> mapEventToState(CouponEvent event) async* {
   try{
     yield CouponLoading();
     if(event is GetCoupon){
       Coupon coupon=await couponRepository.checkCoupon(event.code);
       yield CouponLoaded(coupon);
     }
   }catch (exception) {
     print("CouponBloc exception : "+exception.toString());
     // Yield error with message, exception can't be casted to string in some cases
     try {
       yield CouponError(exception.toString());
     } catch (_) {
       yield CouponError("Error occurred");
     }
   }
  }
}
