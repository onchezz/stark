// import 'package:account_connect/test_packages/relayer_service.dart';
// ignore_for_file: avoid_print

import './relayer_service.dart';
import 'package:flutter/material.dart';
import 'package:starknet/starknet.dart';

class Relayer extends StatefulWidget {
  const Relayer({super.key});

  @override
  State<Relayer> createState() => _RelayerState();
}

class _RelayerState extends State<Relayer> {
  int _totalBalance = 0;
  String _relayerWalletBal = "0";
  int _relayerBal = 0;
  final TextEditingController _amount = TextEditingController();

  Future _getWalletBalance() async {
    Uint256 bal = await getSignerWalletBal();
    setState(() {
      _relayerWalletBal = bal.toString();
    });
  }

  Future _viewTotalVaultbal() async {
    int bal = await getTotalVaultBalance();
    setState(() {
      _totalBalance = bal;
    });
  }

  Future _getPersonalBal() async {
    print('getting personal reayer balance');
    int bal = await viewUserBalance();
    setState(() {
      _relayerBal = bal;
    });
    print('getting personal reayer balance $bal ');
  }

  Future _approveUsdcToken() async {
    int amount = int.parse(_amount.text.trim());
    print("approving usdc amount while regestering ");

    await approveUsdcToken(amount);
    // await regesteringUser(amount);
    _amount.clear();
  }

  Future _regesterUser() async {
    int amount = int.parse(_amount.text.trim());
    print(" regestering ");

    // await approveUsdcToken(amount);
    await regesteringUser(amount);
    _amount.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Available Total liquidity balance is : $_totalBalance"),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("relayer balance is : $_relayerBal"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text("wallet ball $_relayerWalletBal"),
              const SizedBox(
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (() => _getWalletBalance()),
                    child: const Text('Wallet bal'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (() => _viewTotalVaultbal()),
                    child: const Text('Vault bal'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (() => _getPersonalBal()),
                    child: const Text('relayer vault bal'),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _amount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your Amount',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (() => _regesterUser()),
                    child: const Text('regester user'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: (() => _approveUsdcToken()),
                    child: const Text('Approve usdc'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  //   ElevatedButton(
                  //     onPressed: (() => _getPersonalBal()),
                  //     child: const Text('relayer vault bal'),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
