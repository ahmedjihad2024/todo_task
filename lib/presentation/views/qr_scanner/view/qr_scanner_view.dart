import 'dart:async';
import 'dart:io';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:todo_task/app/extensions.dart';

import '../../../common/after_layout.dart';
import '../../../common/toast.dart';
import '../../../common/windows_qr_scanner.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with WidgetsBindingObserver {
  ValueNotifier<bool> cameraReady = ValueNotifier(false);
  String? code;

  Future<void> initCamera() async {
    // add this first before await WindowsQrScanner().initCamera();
    WindowsQrScanner().onCameraInitialized((value) {
      print("Camera Initialized State, $value");
      cameraReady.value = true;
    });

    await WindowsQrScanner().initQrSdk();
    try{
      await WindowsQrScanner().initCamera();
    }on PlatformException catch(e){
      showToast(
          msg: 'Some thing wrong',
          type: ToastificationType.warning
      , context: context);
      Navigator.of(context).pop();
    }on CameraException catch(e){
      showToast(
          msg: e.description ?? 'Some thing wrong',
          type: ToastificationType.warning
          , context: context);
      Navigator.of(context).pop();
    }catch(e){
      Navigator.of(context).pop();
    }

    WindowsQrScanner().onCameraClosed((value) {
      print("Camera Closed");
      try {
        cameraReady.value = false;
      } catch (e) {}
      Navigator.of(context).pop(code);
    });

    WindowsQrScanner().onCameraError((value) async {
      print("Error from camera : ${value.description}");
      await WindowsQrScanner().disposeCurrentCamera();
      await WindowsQrScanner().initCamera();
    });

    WindowsQrScanner().onResult((value) async {
      if (value.isNotEmpty) {
        code = value.first.text;
        await WindowsQrScanner().dispose();
      }
    });
  }

  Future<void> selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null){
      var res = await WindowsQrScanner().scanImageFile(result.files.first.path!);
      if(res != null && res.isNotEmpty){
        code = res.first.text;
        await WindowsQrScanner().dispose();
      }
    }
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: cameraReady,
          builder: (_, value, child) {
            return Center(
                child: value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: WindowsQrScanner().preview?.height ?? 500,
                              width: WindowsQrScanner().preview?.width ?? 300,
                              child: CameraPlatform.instance
                                  .buildPreview(WindowsQrScanner().cameraId),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  await WindowsQrScanner().dispose();
                                },
                                style: ButtonStyle(
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size(100, 50)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        context.colorScheme.primary),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                                child: Text(
                                  "Back",
                                  style: context.small.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: context.theme.colorScheme
                                          .onPrimaryContainer),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  selectImage();
                                },
                                style: ButtonStyle(
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size(100, 50)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        context.colorScheme.primary),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)))),
                                child: Text(
                                  "Choose image",
                                  style: context.small.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: context.theme.colorScheme
                                          .onPrimaryContainer),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : CircularProgressIndicator(
                        color: context.colorScheme.onPrimary,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 3,
                      ));
          }),
    );
  }

}
