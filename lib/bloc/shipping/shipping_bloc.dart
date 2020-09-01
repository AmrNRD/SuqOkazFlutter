import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/repositories/shipping_method.repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  ShippingBloc(this.shippingMethodRepository) : super(ShippingInitial());

  final ShippingMethodRepository shippingMethodRepository;

  @override
  Stream<ShippingState> mapEventToState(
    ShippingEvent event,
  ) async* {
    try {
      yield ShippingLoadingState();
      if (event is GetAllShippingEvent) {
        List<ShippingMethod> list =
            await shippingMethodRepository.loadShippingMethod();
        yield ShippingListLoadedState(list);
      }
    } catch (exception) {
      // Yield error with message, exception can't be casted to string in some cases
      try {
        yield ShippingErrorState(exception.toString());
      } catch (_) {
        yield ShippingErrorState("Error occurred"); // TODO: translate
      }
    }
  }
}
