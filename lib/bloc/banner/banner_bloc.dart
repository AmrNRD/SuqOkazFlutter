import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/banner_model.dart';
import 'package:suqokaz/data/sources/remote/base/api_caller.dart';
import 'package:suqokaz/utils/constants.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerLoadingState());

  APICaller _apiCaller = APICaller();

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    if (event is GetBannerEvent) {
      yield BannerLoadingState();
      _apiCaller.setUrl("${Constants.baseUrl}/wp-json/wp/v2/bannersss");
      var rawData = await _apiCaller.getData();
      List<BannerModel> banners = [];
      rawData.forEach((element) {
        banners.add(BannerModel.fromJson(element));
      });

      yield BannerLoadedState(banners.reversed.toList());
    }
  }
}
