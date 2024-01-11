import './test_packages/relayer_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:starknet/starknet.dart';
// import 'package:starknet_flutter/starknet_flutter.dart';

// Future<void> main() async {
//   const nodeUri = 'https://starknet-goerli.infura.io/v3/872474efe7554d4d8891b17444ceb31a';
//   await StarknetFlutter.init(
//     nodeUri: (nodeUri.isNotEmpty) ? Uri.parse(nodeUri) : infuraGoerliTestnetUri,
//   );

//   runApp(const SmartApp());
// }
void main() {
  runApp(const SmartApp());
}

class SmartApp extends StatelessWidget {
  const SmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StarkNet Wallet in Flutter",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: const Relayer(),
    );
  }
}
