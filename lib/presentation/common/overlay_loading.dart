import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_task/presentation/res/color_manager.dart';

class OverlayLoading {
  final BuildContext _context;
  OverlayEntry? overlayEntry;
  late Future<void> Function() _hideFunction;

  OverlayLoading(this._context,);

  void showLoading() {
    overlayEntry = OverlayEntry(
        builder: (con) => Theme(
            data: Theme.of(_context),
            child: RegisterLoading(overlayLoading: this)));
    Overlay.of(_context).insert(overlayEntry!);
  }

  Future<void> hideLoading() async {
    try{
      await _hideFunction();
    }catch(e){
      Timer.periodic(const Duration(milliseconds: 100), (t) async{
        try{
          await _hideFunction();
          t.cancel();
        }catch(e){
          print(e);
        }
      });
    }
  }

  void setHideFunction(Future<void> Function() fun) => _hideFunction = fun;
}

class RegisterLoading extends StatefulWidget {
  final OverlayLoading overlayLoading;

  const RegisterLoading({super.key, required this.overlayLoading});

  @override
  State<RegisterLoading> createState() => _RegisterLoadingState();
}

class _RegisterLoadingState extends State<RegisterLoading>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Duration animationDuration;

  // *
  late AnimationController loopAnimationController;
  late Animation<double> loopAnimation;
  late Duration loopAnimationDuration;

  @override
  void initState() {
    animationDuration = const Duration(milliseconds: 200);
    loopAnimationDuration = const Duration(milliseconds: 700);

    animationController = AnimationController(
        vsync: this,
        duration: animationDuration,
        reverseDuration: animationDuration);

    loopAnimationController = AnimationController(
        vsync: this,
        duration: loopAnimationDuration,
        reverseDuration: loopAnimationDuration);

    animation = animationController
        .drive(CurveTween(curve: Curves.easeInOutQuad))
        .drive(Tween(begin: 0.0, end: 1.0));
    loopAnimation = loopAnimationController
        .drive(CurveTween(curve: Curves.easeInOutQuad))
        .drive(Tween(begin: 0, end: .15));

    widget.overlayLoading.setHideFunction(() async {
      // do animation before hiding
      animationController.stop(canceled: true); // this line is important
      await animationController.reverse();
      loopAnimationController.stop(canceled: true);

      widget.overlayLoading.overlayEntry!.remove();
    });

    animationController.forward();
    loopAnimationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    loopAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorManager.transparent,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Opacity(
              opacity: animation.value,
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: ColorManager.black.withOpacity(.6)),
                child: CircularProgressIndicator(
                  color: ColorManager.white.withOpacity(.85),
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                ),
              ),
            );
          }),
    );
  }
}
