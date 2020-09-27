part of 'banner_bloc.dart';

abstract class BannerState {
  const BannerState();
}

class BannerLoadingState extends BannerState {}

class BannerLoadedState extends BannerState {
  final List<BannerModel> banners;

  BannerLoadedState(
    this.banners,
  );
}

class BannerErrorState extends BannerState {
  final String message;

  BannerErrorState({
    this.message,
  });
}
