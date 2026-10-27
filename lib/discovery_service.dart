import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';

import 'device.dart';

const _domain = '_googlecast._tcp';

class CastDiscoveryService {
  static final CastDiscoveryService _instance = CastDiscoveryService._();
  CastDiscoveryService._();

  factory CastDiscoveryService() {
    return _instance;
  }

  Future<List<CastDevice>> search({Duration timeout = const Duration(seconds: 5)}) async {
    final results = <CastDevice>[];

    final discovery = BonsoirDiscovery(type: _domain);
    await discovery.initialize();

    discovery.eventStream!.listen((event) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          event.service.resolve(discovery.serviceResolver);
        case BonsoirDiscoveryServiceResolvedEvent():
          final service = event.service;
          final port = service.port;
          // An IPv4 address when the platform resolved one, else any address, else the mDNS hostname
          // (`xxx.local.`). Bonsoir lists addresses in arrival order, so an IPv6 link-local address can come
          // first, and connecting to a Chromecast through one often fails.
          final host = service.hostAddresses.firstWhere(
            (address) => InternetAddress.tryParse(address)?.type == InternetAddressType.IPv4,
            orElse: () => service.hostAddress ?? service.hostname ?? '',
          );

          String name = [
            service.attributes['md'],
            service.attributes['fn'],
          ].whereType<String>().join(' - ');
          if (name.isEmpty) {
            name = service.name;
          }

          if (host.isEmpty) {
            return;
          }

          results.add(
            CastDevice(
              serviceName: service.name,
              name: name,
              port: port,
              host: host,
              extras: service.attributes,
            ),
          );
        default:
          break;
      }
    }, onError: (error) {
      print('[CastDiscoveryService] error ${error.runtimeType} - $error');
    });

    await discovery.start();
    await Future.delayed(timeout);
    await discovery.stop();

    return results.toSet().toList();
  }
}
