class Constants {
  // WooCommerce configuration
  static bool hideOutOfStock = false;

  // Base
  static const appName = "SuqOkaz";
  static const baseUrl = "https://suqokaz.com";
  static bool isRTL = false;
  static const dummyProfilePic = "";

  //Route names
  static const mainPage = "/";
  static const authPage = "/authPage";
  static const homePage = "/mainPage";
  static const editProfilePage = "/editProfilePage";
  static const myOrderPage = "/myOrderPage";
  static const checkoutPage = "/checkoutPage";
  static const paymentPage = "/paymentPage";
  static const orderDetailsPage = "/orderDetailsPage";
  static const addressesPage = "/AddressesPage";
  static const productDetailsPage = "/ProductDetailsPage";
  static const categoryPage = "/CategoryPage";
  static const addAddressScreen = "/addLocation";
  static const editAddressScreen = "/editLocation";
  static const searchScreen = "/searchScreen";
  static const productCategoriesPage = "/ProductCategoriesPage";

  // Keys
  static const consumerKey =
      "ck_84bf021fb3836e4daa569acf30a4ed7b67485163"; // suqokaz
  static const consumerSecret =
      "cs_c1c1fd46e311cd7c2625012b9f6337623034490b"; // suqokaz

  // Local Keys
  static const kLocalKey = {
    "userInfo": "userInfo",
    "shippingAddress": "shippingAddress",
    "recentSearches": "recentSearches",
    "wishlist": "wishlist",
    "home": "home",
    "cart": "cart"
  };

  static const kPaymentConfig = {"DefaultCountryISOCode": "SA"};

  static const kAdvanceConfig = {
    "DefaultLanguage": "ar",
    "DefaultCurrency": {
      "symbol": "EGP ",
      "decimalDigits": 1,
      "symbolBeforeTheNumber": false,
      "currency": "EGP"
    },
  };

  // Images
  static final Map<String, String> imagePath = {
    "delivery_success": "assets/icons/done_icon.svg",
    "empty_box": "assets/icons/box_icon.svg",
    "search_magnifier": "assets/icons/magnifier_icon.svg",
    "error": "assets/icons/error_icon.svg",
  };
  static String kDefaultImage =
      "https://trello-attachments.s3.amazonaws.com/5d64f19a7cd71013a9a418cf/640x480/1dfc14f78ab0dbb3de0e62ae7ebded0c/placeholder.jpg";
}
