//
//
//class DummyData {
////   final List<SavedLocations> savedLocations = [
////     SavedLocations(
////       1,
////       "Holmes 1",
////       "Alexandria",
////       "Mustafa Kamel",
////       "35 Medhat Al Meligi",
////       "in front of TOLIP hotel",
////       "123456789",
////       "01245678910",
////       LatLng(31.232196007174057, 29.946481101214886),
////     ),
////     SavedLocations(
////       2,
////       "Holmes 2",
////       "Alexandria",
////       "Ezbet Saad",
////       "11 EL-Mosheer Mohammed Ali Fahmy",
////       "in front military police",
////       "123456789",
////       "01245678910",
////       LatLng(31.207828032621045, 29.949692711234093),
////     ),
////   ];
//// LatLng(31.227447514695523, 29.953900426626205)
//  final List<NotficationModel> notfications = [
//    NotficationModel(
//      1,
//      "Order request",
//      "A member of your team \"Ahmed Mohsen\" requested this order.\nCheck the order now and approve it!",
//      "2019-10-10",
//    ),
//    NotficationModel(
//      2,
//      "Order placed successfuly",
//      "A member of your team \"Mohamed ELTorky\" made this order.\nClick here for order details.",
//      "2019-10-10",
//    ),
//    NotficationModel(
//      3,
//      "Balance warning!",
//      "A member of your team \"Mohamed Salah\" consumed all his monthly credit allowance!",
//      "2019-10-10",
//    ),
//    NotficationModel(
//      4,
//      "Shipment on the way!",
//      "Shipment no. 1234124 of order 9123423 is it on it's way to you, please be at the selected location btween 02:00 - 04:00 PM",
//      "2019-10-10",
//    ),
//  ];
//
//  final List<TeamMemberModel> teamMembers = [
//    TeamMemberModel(
//      "ahmedmohsen@gmail.com",
//      id: 1,
//      name: "Ahmed Mohsen",
//      privialges: [
//        MemberPrivilagesModel(1, "Use Credit", true),
//        MemberPrivilagesModel(2, "Add Credit", true),
//        MemberPrivilagesModel(3, "Access Order History", true),
//        MemberPrivilagesModel(4, "Order Items", true),
//        MemberPrivilagesModel(5, "Add Items To CartList", true),
//        MemberPrivilagesModel(6, "View CartList", true),
//        MemberPrivilagesModel(7, "View Team Members", true),
//        MemberPrivilagesModel(8, "Add Location", true),
//      ],
//      status: "Un-verfied",
//      creditAllowance: 10000,
//    ),
//    TeamMemberModel(
//      "mo-salah@liverpool.club",
//      id: 2,
//      name: "Mohamed Salah",
//      privialges: [
//        MemberPrivilagesModel(1, "Use Credit", true),
//        MemberPrivilagesModel(2, "Add Credit", true),
//        MemberPrivilagesModel(4, "Order Items", true),
//        MemberPrivilagesModel(8, "Add Location", true),
//      ],
//      status: "Verfied",
//      creditAllowance: 10,
//    ),
//    TeamMemberModel(
//      "mohamedAmr@moamr.dev",
//      id: 3,
//      name: "Mohamed Amr",
//      privialges: [
//        MemberPrivilagesModel(1, "Use Credit", true),
//        MemberPrivilagesModel(3, "Access Order History", true),
//        MemberPrivilagesModel(5, "Add Items To CartList", true),
//      ],
//      status: "Verfied",
//      creditAllowance: 0,
//    ),
//  ];
//
//  final List<PrivilagesModel> privlagesList = [
//    PrivilagesModel(1, "Use Credit"),
//    PrivilagesModel(2, "Add Credit"),
//    PrivilagesModel(3, "Access Order History"),
//    PrivilagesModel(4, "Order Items"),
//    PrivilagesModel(5, "Add Items To CartList"),
//    PrivilagesModel(6, "View CartList"),
//    PrivilagesModel(7, "View Team Members"),
//    PrivilagesModel(8, "Add Location"),
//  ];
//
//  final List<CartListModel> cartList = [
//    CartListModel(
//      "Vegetables",
//      "Mohamed ELTorky",
//      "2019-10-01",
//      id: 1,
//    ),
//    CartListModel(
//      "Meat",
//      "Mohamed ELTorky",
//      "2019-11-01",
//      id: 2,
//    ),
//    CartListModel(
//      "Beverages",
//      "Ahmed Mohsen",
//      "2019-09-01",
//      id: 3,
//    ),
//  ];
//
//  // final List<Category> category = [
//  //   Category(1, "Kitchen"),
//  //   Category(2, "Electronics"),
//  //   Category(3, "Appliances"),
//  // ];
//  // final List<Category> kitchenSubCategory = [
//  //   Category(11, "Vegetables"),
//  //   Category(12, "Meat"),
//  //   Category(13, "Seasonings"),
//  //   Category(14, "Beverages"),
//  //   Category(15, "Nuts"),
//  //   Category(16, "Seeds"),
//  //   Category(17, "Chocolates"),
//  //   Category(18, "Dairy Products"),
//  // ];
//  // final List<Category> electronicsSubCategory = [
//  //   Category(21, "Mobile Phones"),
//  //   Category(22, "Laptops"),
//  //   Category(23, "Desktops"),
//  //   Category(24, "Smart Watches"),
//  //   Category(25, "Prehperials"),
//  // ];
//  // final List<Category> appliancesSubCategory = [
//  //   Category(31, "Air Conditioner"),
//  //   Category(31, "Washing Machines"),
//  //   Category(33, "Oven and cookers"),
//  //   Category(34, "Heaters"),
//  //   Category(35, "Irons"),
//  //   Category(36, "Fans"),
//  //   Category(37, "Water Dispnser"),
//  // ];
//
//  final List<Product> mobilePhones = [
//    Product(
//      1,
//      "Tomato",
//      "10 - 200 LE",
//      "https://images2.minutemediacdn.com/image/upload/c_crop,h_843,w_1500,x_0,y_157/f_auto,q_auto,w_1100/v1555154839/shape/mentalfloss/502435-istock-157773518.jpg",
//      "Fruit",
//    ),
//    Product(
//      2,
//      "Lemon",
//      "40 - 1000 LE",
//      "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/lemon-health-benefits-1296x728-feature.jpg?w=1155&h=1528",
//      "Fruit",
//    ),
//    Product(
//      1,
//      "Eggplant",
//      "30 - 500 LE",
//      "https://images-na.ssl-images-amazon.com/images/I/51wl7MJ75pL._SX425_.jpg",
//      "Veges",
//    )
//  ];
//  final Product selectedProduct = Product(
//    1,
//    "Tomato",
//    "10 - 1000 LE",
//    "https://images2.minutemediacdn.com/image/upload/c_crop,h_843,w_1500,x_0,y_157/f_auto,q_auto,w_1100/v1555154839/shape/mentalfloss/502435-istock-157773518.jpg",
//    "Veges",
//    attribute: [
//      Attribute(
//        1,
//        "Killos",
//        [
//          Value(1, "1 Killo"),
//          Value(2, "5 Killo"),
//          Value(3, "10 Killo"),
//          Value(4, "25 Killo"),
//        ],
//      ),
//    ],
//  );
//
//  final MonthReport monthReport = MonthReport(
//    totalOrderCount: 2,
//    totalCanceldOrders: 0,
//    totalInProgressOrders: 1,
//    totalSuccessfulOrders: 1,
//    totalSpendings: 36300.0,
//    totalItemsBought: 82,
//  );
//
//  final List<OrderHistoryModel> orderHistory = [
//    OrderHistoryModel(
//      id: 9012345,
//      orderDelvieryLocation: "Smouha",
//      orderStatus: "Inprogress",
//      orderTotalPrice: 16300,
//      orderItemsQuantity: 36,
//      orderIssuer: "Mohamed ELTorky",
//      orderIssueDate: "2019-11-27",
//    ),
//    OrderHistoryModel(
//      id: 8057328,
//      orderDelvieryLocation: "Smouha",
//      orderStatus: "Completed",
//      orderTotalPrice: 20000,
//      orderItemsQuantity: 46,
//      orderIssuer: "Ahmed Mohsen",
//      orderIssueDate: "2019-11-20",
//    ),
//  ];
//
//  // final List<ShipmentDetails> shipmentDetails = [
//  //   ShipmentDetails(
//  //     id: 1123045685,
//  //     orderItemsQuantity: 14,
//  //     orderTotalItemPrice: 12000,
//  //     orderTotalTaxes: 300,
//  //     orderTotalPrice: 12300.0,
//  //     status: "Deliverd",
//  //     orderItems: [
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of tomatoes",
//  //         itemPrice: 500.0,
//  //         itemsTotalPrice: 5000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 514.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Carrots",
//  //         itemPrice: 300.0,
//  //         itemsTotalPrice: 3000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 314.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Cucumber",
//  //         itemPrice: 100.0,
//  //         itemsTotalPrice: 1000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 114.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Eggplant",
//  //         itemPrice: 200.0,
//  //         itemsTotalPrice: 2000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 214.0,
//  //       ),
//  //     ],
//  //   ),
//  //   ShipmentDetails(
//  //     id: 1123565699,
//  //     orderItemsQuantity: 14,
//  //     orderTotalItemPrice: 12000,
//  //     orderTotalTaxes: 300,
//  //     orderTotalPrice: 12300.0,
//  //     status: "Processing",
//  //     orderItems: [
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of tomatoes",
//  //         itemPrice: 500.0,
//  //         itemsTotalPrice: 5000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 514.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Carrots",
//  //         itemPrice: 300.0,
//  //         itemsTotalPrice: 3000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 314.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Cucumber",
//  //         itemPrice: 100.0,
//  //         itemsTotalPrice: 1000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 114.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Eggplant",
//  //         itemPrice: 200.0,
//  //         itemsTotalPrice: 2000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 214.0,
//  //       ),
//  //     ],
//  //   ),
//  //   ShipmentDetails(
//  //     id: 1153042646,
//  //     orderItemsQuantity: 14,
//  //     orderTotalItemPrice: 12000,
//  //     orderTotalTaxes: 300,
//  //     orderTotalPrice: 12300.0,
//  //     status: "Shipped",
//  //     orderItems: [
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of tomatoes",
//  //         itemPrice: 500.0,
//  //         itemsTotalPrice: 5000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 514.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Carrots",
//  //         itemPrice: 300.0,
//  //         itemsTotalPrice: 3000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 314.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Cucumber",
//  //         itemPrice: 100.0,
//  //         itemsTotalPrice: 1000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 114.0,
//  //       ),
//  //       OrderItems(
//  //         id: 1230,
//  //         itemName: "10 Killos of Eggplant",
//  //         itemPrice: 200.0,
//  //         itemsTotalPrice: 2000.0,
//  //         itemQuantity: 10,
//  //         itemTaxes: 214.0,
//  //       ),
//  //     ],
//  //   ),
//  // ];
//
//  final List<SKU> selectedProductSKU = [
//    SKU(
//      1,
//      "1 Killo of fresh Lemon.",
//      "The lemon, Citrus limon (L.) Osbeck, is a species of small evergreen tree in the flowering plant family Rutaceae, native to South Asia, primarily North eastern India.\nThe tree's ellipsoidal yellow fruit is used for culinary and non-culinary purposes throughout the world, primarily for its juice, which has both culinary and cleaning uses. The pulp and rind are also used in cooking and baking. The juice of the lemon is about 5% to 6% citric acid, with a pH of around 2.2, giving it a sour taste. The distinctive sour taste of lemon juice makes it a key ingredient in drinks and foods such as lemonade and lemon meringue pie.",
//      40,
//      [
//        "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/lemon-health-benefits-1296x728-feature.jpg?w=1155&h=1528",
//      ],
//      [
//        Attribute(
//          1,
//          "Wieght",
//          [
//            Value(1, "1 Killo"),
//          ],
//        ),
//      ],
//      count: 20,
//    ),
//    SKU(
//      2,
//      "5 Killo of fresh Lemon.",
//      "The lemon, Citrus limon (L.) Osbeck, is a species of small evergreen tree in the flowering plant family Rutaceae, native to South Asia, primarily North eastern India.\nThe tree's ellipsoidal yellow fruit is used for culinary and non-culinary purposes throughout the world, primarily for its juice, which has both culinary and cleaning uses. The pulp and rind are also used in cooking and baking. The juice of the lemon is about 5% to 6% citric acid, with a pH of around 2.2, giving it a sour taste. The distinctive sour taste of lemon juice makes it a key ingredient in drinks and foods such as lemonade and lemon meringue pie.",
//      200,
//      [
//        "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/lemon-health-benefits-1296x728-feature.jpg?w=1155&h=1528",
//      ],
//      [
//        Attribute(
//          1,
//          "Wieght",
//          [
//            Value(2, "5 Killo"),
//          ],
//        ),
//      ],
//      count: 20,
//    ),
//    SKU(
//      3,
//      "10 Killo of fresh Lemon.",
//      "The lemon, Citrus limon (L.) Osbeck, is a species of small evergreen tree in the flowering plant family Rutaceae, native to South Asia, primarily North eastern India.\nThe tree's ellipsoidal yellow fruit is used for culinary and non-culinary purposes throughout the world, primarily for its juice, which has both culinary and cleaning uses. The pulp and rind are also used in cooking and baking. The juice of the lemon is about 5% to 6% citric acid, with a pH of around 2.2, giving it a sour taste. The distinctive sour taste of lemon juice makes it a key ingredient in drinks and foods such as lemonade and lemon meringue pie.",
//      400,
//      [
//        "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/lemon-health-benefits-1296x728-feature.jpg?w=1155&h=1528",
//      ],
//      [
//        Attribute(
//          1,
//          "Wieght",
//          [
//            Value(3, "10 Killo"),
//          ],
//        ),
//      ],
//      count: 12,
//    ),
//    SKU(
//      4,
//      "25 Killo of fresh Lemon.",
//      "The lemon, Citrus limon (L.) Osbeck, is a species of small evergreen tree in the flowering plant family Rutaceae, native to South Asia, primarily North eastern India.\nThe tree's ellipsoidal yellow fruit is used for culinary and non-culinary purposes throughout the world, primarily for its juice, which has both culinary and cleaning uses. The pulp and rind are also used in cooking and baking. The juice of the lemon is about 5% to 6% citric acid, with a pH of around 2.2, giving it a sour taste. The distinctive sour taste of lemon juice makes it a key ingredient in drinks and foods such as lemonade and lemon meringue pie.",
//      1000,
//      [
//        "https://i0.wp.com/images-prod.healthline.com/hlcmsresource/images/AN_images/lemon-health-benefits-1296x728-feature.jpg?w=1155&h=1528",
//      ],
//      [
//        Attribute(
//          1,
//          "Wieght",
//          [
//            Value(1, "25 Killo"),
//          ],
//        ),
//      ],
//      count: 12,
//    ),
//  ];
//}
