import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:suqokaz/data/models/payment_method_model.dart';
import 'package:suqokaz/data/repositories/payment_method.repository.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  PaymentMethodBloc(this.paymentMethodRepository)
      : super(PaymentMethodInitial());
  PaymentMethodRepository paymentMethodRepository;
  @override
  Stream<PaymentMethodState> mapEventToState(
    PaymentMethodEvent event,
  ) async* {
    try {
      yield PaymentMethodLoadingState();
      if (event is GetAllPaymentMethodEvent) {
        List<PaymentMethod> list =
            await paymentMethodRepository.loadPaymentMethod();
        yield PaymentMethodListLoadedState(list);
      }
    } catch (exception) {
      // Yield error with message, exception can't be casted to string in some cases
      try {
        yield PaymentMethodErrorState(exception.toString());
      } catch (_) {
        yield PaymentMethodErrorState("Error occurred"); // TODO: translate
      }
    }
  }
}
