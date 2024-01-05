import 'package:mapapp/importer.dart';

class DeepLinkwModel {
  StreamSubscription? _sub; // _sub の宣言
  StreamController<DeepLinkResult> _deepLinkResultController =
      StreamController.broadcast();

  // 外部からアクセス可能なストリーム
  Stream<DeepLinkResult> get deepLinkResultStream =>
      _deepLinkResultController.stream;

  // アプリ開始時に初期URIを取得
  Future<void> initURIHandler() async {
    try {
      final Uri? initialURI = await getInitialUri();
      print('Initial URI: $initialURI');
      // 初期URIに基づいて必要なアクションを実行
      if (initialURI != null) {
        handleDeepLink(initialURI);
      }
    } on PlatformException {
      debugPrint("Failed to receive initial uri");
    }
  }

  // DeepLinkを監視する
  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      print('New link: $uri');
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint('Error occurred: $err');
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void handleDeepLink(Uri uri) async {
    print('Received deep link: $uri');

    final host = uri.host;
    final pathSegments = uri.pathSegments;
    print('Handling deep link with host: $host, path: $pathSegments');

    if (host == 'spot' && pathSegments.isNotEmpty) {
      final String spotIdString = pathSegments.first;
      final int? spot = int.tryParse(spotIdString);
      if (spot != null) {
        // ディープリンクの結果をストリームに追加
        _deepLinkResultController.add(DeepLinkResult('spot', spot));
      }
    } else if (host == 'plan' && pathSegments.isNotEmpty) {
      final String planIdString = pathSegments.first;
      final int? planId = int.tryParse(planIdString);
      if (planId != null) {
        _deepLinkResultController.add(DeepLinkResult('plan', planId));
      }
    } else if (host == 'ivent' && pathSegments.isNotEmpty) {
      final String placeIdString = pathSegments.first;
      final int? placeId = int.tryParse(placeIdString);
      if (placeId != null) {
        _deepLinkResultController.add(DeepLinkResult('ivent', placeId));
      }
    }
  }

  // リソースの解放
  void dispose() {
    _sub?.cancel(); // _sub をキャンセル
    _deepLinkResultController.close();
  }
}

// ディープリンクの結果を表すクラス
class DeepLinkResult {
  final String type;
  final int id;

  DeepLinkResult(this.type, this.id);
}
