import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/data/models/review_model.dart';
import 'package:suqokaz/ui/common/custom_cancel_save.component.dart';
import 'package:suqokaz/ui/common/input_field.dart';
import 'package:suqokaz/ui/common/star.rating.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/validators.dart';
import 'package:toast/toast.dart';

class AddReviewSheet extends StatefulWidget {
  final int productId;
  final BuildContext parentContext;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AddReviewSheet({
    Key key,
    @required this.productId,
    @required this.parentContext,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _AddReviewSheetState createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  int rating = 0;
  TextEditingController reviewController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  Validator _validator;
  ReviewModel review;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    review = ReviewModel();
    review.rating = 0;
    review.productId = widget.productId;
    print(widget.productId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = Validator(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      cubit: BlocProvider.of<ReviewBloc>(widget.parentContext),
      listener: (BuildContext context, ReviewState state) {
        print(state.runtimeType);
        if (state is ReviewSubmitLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is ReviewSubmitedState) {
          setState(() {
            isLoading = false;
          });

          BlocProvider.of<ReviewBloc>(widget.parentContext).add(
            GetProductReviewsEvent(
              widget.productId.toString(),
            ),
          );
          widget.scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
              content: Text(
                AppLocalizations.of(context).translate("review_add_success"),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.white),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is ReviewSubmitError) {
          setState(() {
            isLoading = false;
          });
          Toast.show(
            state.message,
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.red,
            backgroundRadius: 5,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 100,
                height: 5,
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: AppColors.customGreyLevels[50].withOpacity(0.1),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 12),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("rate_product"),
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Color(0xFFE8E8E8).withOpacity(0.3),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: AppDimens.marginDefault16,
                        ),
                        Text(
                          AppLocalizations.of(context).translate("rate"),
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault8,
                        ),
                        SmoothStarRating(
                          label: Text(''),
                          allowHalfRating: false,
                          onRatingChanged: updateRating,
                          starCount: 5,
                          rating: rating + 0.0,
                          size: 38.0,
                          color: AppColors.primaryColors[50],
                          borderColor: AppColors.customGreyLevels[200],
                          spacing: 0.0,
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate("your_review"),
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault8,
                        ),
                        CustomInputTextField(
                          controller: reviewController,
                          autoFoucs: true,
                          validator: (value) {
                            return _validator.isEmpty(
                              value,
                              AppLocalizations.of(context)
                                  .translate("your_review"),
                            );
                          },
                          maxLines: 10,
                          minLines: 5,
                          textInputType: TextInputType.multiline,
                          isCollapes: true,
                          onSave: (value) {
                            review.review = value;
                          },
                          onFieldSubmit: (_) {
                            _nameNode.nextFocus();
                          },
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate("name"),
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault8,
                        ),
                        CustomInputTextField(
                          focusNode: _nameNode,
                          controller: nameController,
                          onSave: (value) {
                            review.reviewerName = value;
                          },
                          validator: (value) {
                            return _validator.isEmpty(
                              value,
                              AppLocalizations.of(context).translate("name"),
                            );
                          },
                          maxLines: 1,
                          minLines: 1,
                          textInputType: TextInputType.multiline,
                          isCollapes: true,
                          onFieldSubmit: (_) {
                            _emailNode.nextFocus();
                          },
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate("email"),
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault8,
                        ),
                        CustomInputTextField(
                          focusNode: _emailNode,
                          controller: emailController,
                          validator: (value) {
                            return _validator.isEmail(value);
                          },
                          maxLines: 1,
                          minLines: 1,
                          textInputType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          isCollapes: true,
                          onSave: (value) {
                            review.reviewerEmail = value;
                          },
                          onFieldSubmit: (_) {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                            }
                          },
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault20,
                        ),
                        CustomCancelSaveComponent(
                          onCancelPress: () {
                            Navigator.pop(context);
                          },
                          isLoading: isLoading,
                          onSavePress: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              BlocProvider.of<ReviewBloc>(widget.parentContext)
                                  .add(
                                SubmitProductReviewEvent(review),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: AppDimens.marginDefault20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateRating(double index) {
    review.rating = index.round();
    setState(() {
      rating = index.toInt();
    });
  }

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
    nameController.dispose();
    emailController.dispose();
  }
}
