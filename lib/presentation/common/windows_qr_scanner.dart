import 'dart:async';
import 'package:camera_windows/camera_windows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:image/image.dart' as img;
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'dart:io' as io;
import 'dart:ui' as ui;

class WindowsQrScanner {
  static FlutterBarcodeSdk? _barcodeReader;
  List<CameraDescription> _cameras = <CameraDescription>[];
  String _selectedItem = '';
  final List<String> _cameraNames = [];
  Size? _previewSize;
  int _cameraId = -1;
  bool _initialized = false;
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;
  StreamSubscription<FrameAvailabledEvent>? _frameAvailableStreamSubscription;
  bool _isScanAvailable = true;
  final ResolutionPreset _resolutionPreset = ResolutionPreset.veryHigh;
  bool _loading = true;
  List<BarcodeResult>? _results;

  int get cameraId => _cameraId;

  Size? get preview => _previewSize;

  // callback
  Function(List<BarcodeResult> result)? _onResultUser;
  Function(CameraErrorEvent event)? _onCameraErrorUser;
  Function(CameraClosingEvent event)? _onCameraClosedUser;
  Function(bool initialized)? _onCameraInitialized;

  static final WindowsQrScanner _instance = WindowsQrScanner._internal();

  WindowsQrScanner._internal();

  factory WindowsQrScanner() {
    return _instance;
  }

  Future<void> initQrSdk() async {
    if (_barcodeReader == null) {
      _barcodeReader = FlutterBarcodeSdk();
      await _barcodeReader!.setLicense(
          'DLS2eyJoYW5kc2hha2VDb2RlIjoiMTAzMzcxNTUxLVRYbFFjbTlxIiwibWFpblNlcnZlclVSTCI6Imh0dHBzOi8vbWRscy5keW5hbXNvZnRvbmxpbmUuY29tIiwib3JnYW5pemF0aW9uSUQiOiIxMDMzNzE1NTEiLCJzdGFuZGJ5U2VydmVyVVJMIjoiaHR0cHM6Ly9zZGxzLmR5bmFtc29mdG9ubGluZS5jb20iLCJjaGVja0NvZGUiOi0xNDAzMzcxMDA3fQ==');
      await _barcodeReader!.init();
      await _barcodeReader!.setBarcodeFormats(BarcodeFormat.QR_CODE);
    }
  }

  Future<void> initCamera() async {
    try {
      _cameras = await CameraPlatform.instance.availableCameras();
      _cameraNames.clear();
      for (CameraDescription description in _cameras) {
        _cameraNames.add(description.name);
      }
      _selectedItem = _cameraNames[0];
    } on PlatformException catch (e) {}

    await _toggleCamera(0);
  }

  /// Initializes the camera on the device.
  Future<void> _toggleCamera(int index) async {
    assert(!_initialized);

    if (_cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      final CameraDescription camera = _cameras[index];

      cameraId = await CameraPlatform.instance.createCamera(
        camera,
        _resolutionPreset,
      );

      _errorStreamSubscription?.cancel();
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      _cameraClosingStreamSubscription?.cancel();
      _cameraClosingStreamSubscription = CameraPlatform.instance
          .onCameraClosing(cameraId)
          .listen(_onCameraClosing);

      _frameAvailableStreamSubscription?.cancel();
      _frameAvailableStreamSubscription =
          (CameraPlatform.instance as CameraWindows)
              .onFrameAvailable(cameraId)
              .listen(_onFrameAvailable);

      final Future<CameraInitializedEvent> initialized =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
        // imageFormatGroup: ImageFormatGroup.bgra8888
      );

      final CameraInitializedEvent event = await initialized;
      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      _initialized = true;
      _cameraId = cameraId;
      _onCameraInitialized?.call(_initialized);
    } on CameraException catch (e) {
      try {
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        debugPrint('Failed to dispose camera: ${e.code}: ${e.description}');
      }

      // Reset state.
      _initialized = false;
      _cameraId = -1;
      _previewSize = null;
      _onCameraInitialized?.call(_initialized);
    }
  }

  void _onFrameAvailable(FrameAvailabledEvent event) {
    // event.bytes
    Map<String, dynamic> map = event.toJson();
    final Uint8List? data = map['bytes'] as Uint8List?;
    if (data != null) {
      if (!_isScanAvailable) {
        return;
      }

      _isScanAvailable = false;
      // _qrCodeFromBytes(data, _previewSize?.width.toInt() ?? 500,
      //         _previewSize?.height.toInt() ?? 500)
      //     .then((result) {
      //   if (result != null) _onResultUser?.call(result);
      //
      //   _isScanAvailable = true;
      // }).catchError((error) {
      //   print(error);
      //   _isScanAvailable = true;
      // });
      // _isScanAvailable = true;
      // // print("*************");

      _barcodeReader
          ?.decodeImageBuffer(
          data,
          _previewSize!.width.toInt(),
          _previewSize!.height.toInt(),
          _previewSize!.width.toInt() * 4,
          ImagePixelFormat.IPF_ARGB_8888.index)
          .then((results) {
        _results = results;

        _onResultUser?.call(results);

        _isScanAvailable = true;
      }).catchError((error) {
        _isScanAvailable = true;
        print(error);
      });
    }
  }

  Future<List<BarcodeResult>?> scanImageFile(String path) async => _barcodeReader?.decodeFile(path);

  // Future<Result?> _qrCodeFromBytes(
  //     Uint8List bytes, int width, int height) async {
  //   final rawImage = img.Image.fromBytes(
  //     width: width,
  //     height: height,
  //     bytes: bytes.buffer,
  //     // format: img.Format.uint32,
  //   );
  //   final jpegBytes = img.encodeJpg(rawImage);
  //   await io.File(
  //           "C:\\Users\\XPRISTO\\Downloads\\images\\${DateTime.now().millisecondsSinceEpoch}.jpg")
  //       .writeAsBytes(jpegBytes);
  //
  //   // img.Image? decodedImage = img.decodeImage(bytes);
  //   // print(decodedImage);
  //   // await io.File("C:\\Users\\XPRISTO\\Downloads\\images\\${DateTime.now().millisecondsSinceEpoch}.jpeg").writeAsBytes(bytes);
  //   // img.Image? image = img.decodeImage(bytes);
  //   // ui.decodeImageFromList(bytes, (ui.Image image){
  //   //   print(image.width);
  //   // });
  //   // print(image);
  //   //
  //   // LuminanceSource source = RGBLuminanceSource(
  //   //     image!.width,
  //   //     image.height,
  //   //     image
  //   //         .convert(numChannels: 4)
  //   //         .getBytes(order: img.ChannelOrder.abgr)
  //   //         .buffer
  //   //         .asInt32List());
  //   // var bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));
  //   //
  //   // var reader = QRCodeReader();
  //   // var result = reader.decode(bitmap);
  //   // print(result.text);
  //   return null;
  // }

  void _onCameraError(CameraErrorEvent event) {
    _onCameraErrorUser?.call(event);
  }

  void _onCameraClosing(CameraClosingEvent event) {
    _onCameraClosedUser?.call(event);
  }

  Future<void> disposeCurrentCamera() async {
    if (_cameraId >= 0 && _initialized) {
      try {
        await CameraPlatform.instance.dispose(_cameraId);

        _initialized = false;
        _cameraId = -1;
        _previewSize = null;
      } on CameraException catch (e) {}
    }
  }

  Future<void> dispose() async {
    await disposeCurrentCamera();
    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;
    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    _frameAvailableStreamSubscription?.cancel();
    _frameAvailableStreamSubscription = null;
    _onResultUser = null;
    _onCameraErrorUser = null;
    _onCameraClosedUser = null;
  }

  void onResult(Function(List<BarcodeResult>  result) callback) {
    _onResultUser ??= callback;
  }

  void onCameraError(Function(CameraErrorEvent event) callback) {
    _onCameraErrorUser = callback;
  }

  void onCameraClosed(Function(CameraClosingEvent event) callback) {
    _onCameraClosedUser = callback;
  }

  void onCameraInitialized(Function(bool initialized) callback) {
    _onCameraInitialized = callback;
  }
}
