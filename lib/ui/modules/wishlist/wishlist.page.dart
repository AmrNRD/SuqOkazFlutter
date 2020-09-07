import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/utils/constants.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GenericState(
        imagePath: Constants.imagePath["empty_box"],
        titleKey: "You don't have any items in the wishlist",
        bodyKey: "Feature will be added in next relese.",
        removeButton: true,
      ),
    );
  }
}
