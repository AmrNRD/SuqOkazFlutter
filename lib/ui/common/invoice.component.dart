import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class InvoiceComponent extends StatelessWidget {
  final bool highlight;
  final bool isDiscount;
  final String startText;
  final String endText;

  const InvoiceComponent({
    Key key,
    this.highlight = false,
    this.isDiscount = false,
    this.startText,
    this.endText,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          startText,
          style: Theme.of(context).textTheme.headline2.copyWith(
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        Text(
          endText,
          style: Theme.of(context).textTheme.headline2.copyWith(
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w300,
                color: isDiscount
                    ? Color(0xFF2D8F1D)
                    : AppColors.primaryColors[200],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
