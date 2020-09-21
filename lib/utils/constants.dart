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
  static const filterPage = "/filterPage";


  // Keys
  static const consumerKey = "ck_cafce6ef4f584a33bb060243680ab920bac3e63d"; // suqokaz
  static const consumerSecret = "cs_a43a0c3bb4b73b1f8428b43f9e1261677e9cd4b2"; // suqokaz



  static const testSecretKey="sk_test_eG5EoySq5ZweGKpqmh4PRVi27ojropNCBifSETzg";
  static const testPublishableKey="pk_test_TekCZgcYEyt6kpsz2sA4ebaPKzUQuFsUp6tyhVJp";

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
    "DefaultCurrency": {"symbol": "EGP ", "decimalDigits": 1, "symbolBeforeTheNumber": false, "currency": "EGP"},
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
