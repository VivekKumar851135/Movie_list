import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hugeicons/hugeicons.dart';

class ConnectivityIcon extends StatelessWidget {
  const ConnectivityIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final status = snapshot.data!;
          switch (status) {
            case ConnectivityResult.none:
              return const Icon(HugeIcons.strokeRoundedCellularNetworkOffline, color: Colors.red);
            case ConnectivityResult.mobile:
              return const Icon(HugeIcons.strokeRoundedCellularNetwork, color: Colors.green);
            case ConnectivityResult.wifi:
              return const Icon(HugeIcons.strokeRoundedWifi01, color: Colors.green);
            default:
              return const Icon(HugeIcons.strokeRoundedCellularNetworkOffline, color: Colors.grey);
          }
        }
        return const Icon(HugeIcons.strokeRoundedCellularNetworkOffline, color: Colors.grey);
      },
    );
  }
}
