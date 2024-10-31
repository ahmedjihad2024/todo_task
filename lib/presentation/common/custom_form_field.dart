import 'dart:io';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nice_text_form/nice_text_form.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:todo_task/app/extensions.dart';

import '../res/color_manager.dart';
import 'after_layout.dart';

class SecurityController {
  late Function() _refresher;
  bool isSecure = true;

  void _setRefresher(Function() refresher) {
    _refresher = refresher;
  }

  void hideText() {
    if (!isSecure) {
      isSecure = true;
      _refresher();
    }
  }

  void showText() {
    if (isSecure) {
      isSecure = false;
      _refresher();
    }
  }
}

class NiceTextForm extends StatefulWidget {
  final SecurityController? controller;
  final double? width;
  final double? height;
  final String? initialSelectionFlag;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? validatorStyle;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textEditingController;
  final void Function(CountryCode countryCode)? countryCode;
  final int? textLength;
  final bool isPhoneForm;
  final EdgeInsetsGeometry? padding;
  final Widget Function(bool isSecure)? sufixWidget;
  final Widget? prefixWidget;
  final FocusNode? focusNode;
  final String? Function(String)? validator;
  final bool? obscureText;
  final Future<Widget?> Function(String text)? searchResultsBuilder;
  final bool showSearchResultsTop;
  final Offset searchResultsOffset;
  final Widget? label;
  final BoxDecoration? boxDecoration;
  final BoxDecoration? activeBoxDecoration;
  final int maxLines;
  final BoxConstraints? boxConstraints;
  final Function(String)? onTextChanged;
  final Alignment alignment;
  final bool showCountryCode;

  const NiceTextForm({super.key,
    this.height,
    required this.hintText,
    this.width,
    this.initialSelectionFlag,
    this.textStyle,
    this.hintStyle,
    this.countryCode,
    this.textEditingController,
    this.keyboardType,
    this.textLength,
    this.isPhoneForm = false,
    this.padding,
    this.sufixWidget,
    this.focusNode,
    this.validator,
    this.validatorStyle,
    this.obscureText = null,
    this.label,
    this.boxDecoration,
    this.activeBoxDecoration,
    this.prefixWidget,
    this.boxConstraints,
    this.searchResultsBuilder,
    this.showSearchResultsTop = false,
    this.searchResultsOffset = const Offset(0, 0),
    this.maxLines = 1,
    this.onTextChanged,
    this.alignment = Alignment.center,
    this.controller = null,
    this.showCountryCode = false});

  @override
  State<NiceTextForm> createState() => _NiceTextFormState();
}

class _NiceTextFormState extends State<NiceTextForm> with AfterLayout {
  String? errorMessage;
  final OverlayPortalController _overlayPortalController =
  OverlayPortalController();
  Widget? _searchWidget;
  late LayerLink _layerLink;
  CancelableOperation<Widget?>? _cancelabelOperation;
  String _value = '';
  bool focused = false;
  late FocusNode focusNode;
  String? selectedCountryCode;

  @override
  void initState() {
    _layerLink = LayerLink();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    if (_overlayPortalController.isShowing) _overlayPortalController.hide();
    focusNode.removeListener(focusListener);
    super.dispose();
  }

  void focusListener() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _searchWidget = widget.searchResultsBuilder?.call(_value);

    widget.controller?._setRefresher(() {
      // to keep focusing on text field when change text visibility
      focusNode.requestFocus();
      focused = true;

      setState(() {});
    });

    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (BuildContext context) {
        return Positioned(
          right: 0,
          child: SearchResultsWidget(
            widget: _searchWidget ?? const SizedBox.shrink(),
            layerLink: _layerLink,
            targetAnchor: widget.showSearchResultsTop
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            followerAnchor: widget.showSearchResultsTop
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            offset: widget.searchResultsOffset,
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  widget.label!
                else
                  const SizedBox.shrink(),
                if (errorMessage != null) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.h),
                    child: Text(
                      errorMessage!,
                      style: widget.validatorStyle,
                    ),
                  ),
                ]
              ],
            ),
            IntrinsicHeight(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: widget.height,
                width: widget.width,
                padding: widget.padding,
                alignment: widget.alignment,
                constraints: widget.boxConstraints,
                decoration: focused && widget.activeBoxDecoration != null
                    ? widget.activeBoxDecoration
                    : widget.boxDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isPhoneForm) ...[
                      CountryCodeButton(
                        initialSelection: widget.initialSelectionFlag ?? "EG",
                        localization: context.deviceLocale,
                        padding: EdgeInsets.zero,
                        width: desktopSize(25.diagonal, 30),
                        height: desktopSize(20.diagonal, 25),
                        dialogWidth: .9 * deviceDetails.width,
                        dialogHeight: .8 * deviceDetails.height,
                        borderRadius: BorderRadius.circular(7.r),
                        onSelectionChange: (countryCode) {
                          setState(() =>  selectedCountryCode = countryCode.dialCode);
                          widget.countryCode?.call(countryCode);
                        },
                        searchFormBuilder: (textController) {
                          return Material(
                            color: Colors.transparent,
                            child: NiceTextForm(
                              height: desktopSize(50.w, 50),
                              padding: EdgeInsets.symmetric( horizontal: desktopSize(15.w, 15)),
                              boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: ColorManager.black.withOpacity(.03)
                              ),
                              hintText: "search",
                              textEditingController: textController,
                              hintStyle: context.small.copyWith(
                                color: ColorManager.black.withOpacity(.5),
                                fontSize: desktopSize(18.sp, 18),
                              ),
                              textStyle: context.small.copyWith(
                                color: ColorManager.black,
                                fontSize: desktopSize(18.sp, 18),
                              ),
                            ),
                          );
                        },
                      ),

                      Platform.isWindows ? const SizedBox(
                        width: 3,
                      ) : 3.horizontalSpace,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: desktopSize(30.sp, 30),
                        color: Colors.black.withOpacity(.3),
                      ),
                      // 5.horizontalSpace,
                      // Container(
                      //   width: 1.5,
                      //   height: double.infinity,
                      //   margin: EdgeInsets.symmetric(vertical: 15.h),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(.1),
                      //     borderRadius: BorderRadius.circular(999),
                      //   ),
                      // ),
                      // 10.horizontalSpace
                    ],
                    if (widget.prefixWidget != null) ...[
                      widget.prefixWidget!,
                      Platform.isWindows ? const SizedBox(
                        width: 5,
                      ) : 9.horizontalSpace
                    ],

                    if(selectedCountryCode != null && widget.showCountryCode) ...[
                      Text(selectedCountryCode!, style: widget.hintStyle?.copyWith(height: 1),),
                      Platform.isWindows ? const SizedBox(
                        width: 4,
                      ) : 4.horizontalSpace
                    ],

                    Expanded(
                      child: TextFormField(
                        style: widget.textStyle,
                        focusNode: focusNode,
                        controller: widget.textEditingController,
                        keyboardType: widget.keyboardType,
                        obscureText: widget.obscureText ??
                            widget.controller?.isSecure ??
                            false,
                        maxLines: widget.maxLines,
                        minLines: 1,
                        inputFormatters: widget.textLength != null
                            ? [
                          LengthLimitingTextInputFormatter(
                              widget.textLength)
                        ]
                            : [],
                        onTapOutside: (_) {
                          setState(() {
                            focused = false;
                          });
                          if (_overlayPortalController.isShowing)
                            _overlayPortalController.hide();
                        },
                        onTap: () {
                          setState(() {
                            focused = true;
                          });
                          if (!_overlayPortalController.isShowing &&
                              _searchWidget != null)
                            _overlayPortalController.show();
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle,
                        ),
                        onChanged: (value) async {
                          if (widget.onTextChanged != null)
                            widget.onTextChanged!(value);
                          _value = value;
                          _cancelabelOperation?.cancel();

                          if (widget.searchResultsBuilder != null) {
                            _cancelabelOperation =
                                CancelableOperation.fromFuture(
                                  widget.searchResultsBuilder!(value),
                                  onCancel: () => null,
                                );
                            Widget? searchW = await _cancelabelOperation?.value;
                            if (searchW != _searchWidget) {
                              _searchWidget = searchW;
                              handleShowingSearchWidget();
                            }
                          }

                          String? msg = widget.validator != null
                              ? widget.validator!(value)
                              : null;
                          if (msg != null) {
                            setState(() => errorMessage = msg);
                          } else if (msg == null && errorMessage != null)
                            setState(() => errorMessage = msg);
                        },
                      ),
                    ),
                    if (widget.sufixWidget != null) ...[
                      Platform.isWindows ? const SizedBox(
                        width: 5,
                      ) : 9.horizontalSpace,
                      widget.sufixWidget!(widget.obscureText ??
                          widget.controller?.isSecure ??
                          false)
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    _searchWidget = await widget.searchResultsBuilder?.call(_value);
    handleShowingSearchWidget();
  }

  void handleShowingSearchWidget() {
    if (_searchWidget == null && _overlayPortalController.isShowing) {
      _overlayPortalController.hide();
    }
    if (_searchWidget != null && !_overlayPortalController.isShowing) {
      _overlayPortalController.show();
    }
  }
}

class SearchResultsWidget extends StatefulWidget {
  final Widget widget;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;
  final LayerLink layerLink;

  const SearchResultsWidget({super.key,
    required this.widget,
    required this.offset,
    required this.followerAnchor,
    required this.targetAnchor,
    required this.layerLink});

  @override
  State<SearchResultsWidget> createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation =
    animationController..drive(Tween<double>(begin: 1, end: 0))..drive(
        CurveTween(curve: Curves.easeInOut));
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (_,
            __,) =>
            Opacity(
              opacity: animation.value,
              child: CompositedTransformFollower(
                offset: Offset(
                    widget.offset.dx, animation.value * widget.offset.dy),
                targetAnchor: widget.targetAnchor,
                followerAnchor: widget.followerAnchor,
                link: widget.layerLink,
                child: widget.widget,
              ),
            ));
  }
}
