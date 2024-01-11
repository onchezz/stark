// ignore_for_file: prefer_const_declarations, avoid_print

import 'dart:math';

import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

final provider = JsonRpcProvider(
  nodeUri: Uri.parse(
    'https://starknet-goerli.infura.io/v3/9fe2088d204c4289bd9ed7e457cbbd67',
  ),
);
final usdcContractAddress =
    '0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426';
final contractAddress =
    '0x06ce09144d7b8082b80c03fd85475cf73152f2796f0cbebb5a5a3105c20c31e5';
final secretAccountAddress =
    "0x0784a3B8B98ED10224998d42dcF800Bdf6641372ba1C1c6a3fb39263AD68648D";
final secretAccountPrivateKey =
    "0x03efaef171afc28c4916ad4c18c058ceeda5830244b1d5bf155465d673d0624d";
final signerAccount = getAccount(
  accountAddress: Felt.fromHexString(secretAccountAddress),
  privateKey: Felt.fromHexString(secretAccountPrivateKey),
  nodeUri: provider.nodeUri,
);

//view functions
//get user balance
Future viewUserBalance() async {
  final result = await provider.call(
    request: FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName("view_user_balance"),
      calldata: [
        signerAccount.accountAddress,
        // Felt.fromHexString(secretAccountAddress),
      ],
    ),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get user balance"),
  );
}

//get user balance
Future viewRelayerVaultBalance() async {
  final result = await provider.call(
    request: FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName("view_relayer_balance"),
      calldata: [
        signerAccount.accountAddress,
      ],
    ),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get relayer balance"),
  );
}

Future getTotalVaultBalance() async {
  final result = await provider.call(
    request: FunctionCall(
      contractAddress: Felt.fromHexString(contractAddress),
      entryPointSelector: getSelectorByName("view_total_balance"),
      calldata: [],
    ),
    blockId: BlockId.latest,
  );
  return result.when(
    result: (result) => result[0].toInt(),
    error: (error) => throw Exception("Failed to get total value"),
  );
}

Future getSignerWalletBal() async {
  Uint256 signerBal = await signerAccount.balance();

  return signerBal;
}

//write functions

//allowing address to use usdc tokens

Future approveUsdcToken(int amount) async {
  final tokenamount = amount * pow(10, 6);
  final res = await signerAccount.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(
          "0x005a643907b9a4bc6a55e9069c4fd5fd1f5c79a22470690f75556c4736e34426",
        ),
        entryPointSelector: getSelectorByName("approve"),
        calldata: [
          Felt.fromHexString(contractAddress),
          Felt.fromInt(tokenamount.toInt()),
          Felt.fromInt(0),
        ],
      ),
    ],
    // maxFee: defaultMaxFee,
  );

  print(
    res.when(
      result: (result) => result.toString(),
      error: (error) => throw Exception(error),
    ),
  );

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print("approved usdc tx $txHash");

  return "txHash";
}
// print(
//   res.when(
//     result: (result) => result.toString(),
//     error: (error) => throw Exception(error),
//   ),
// );

// final txHash = res.when(
//   result: (result) => result.transaction_hash,
//   error: (err) => throw Exception("Failed to execute"),
// );

// Future<String> regesteringUser(int amount) async {
//   print('regstering.....');

// ignore: await_only_futures
// final res = await signerAccount.getNonce().toString();
// execute(
//   functionCalls: [
//     FunctionCall(
//       contractAddress: Felt.fromHexString(contractAddress),
//       entryPointSelector: getSelectorByName('register'),
//       calldata: [Felt.fromIntString(amount)],
//     ),
//   ],
// );

// print(
//   res.toString(),
//   // res.when(
//   //   result: (result) => result.toString(),
//   //   error: (error) => throw Exception(error),
//   // ),
// );

// final txHash = res.when(
//   result: (result) => result.transaction_hash,
//   error: (err) => throw Exception("Failed to execute"),
// );
// print('regester user transaction result:$txHash');
//   return '';
//   // return waitForAcceptance(transactionHash: txHash, provider: provider);
// }

Future<String> regesteringUser(int amount) async {
  print('regstering.....');

  final res = await signerAccount.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName('register'),
        calldata: [Felt.fromInt(amount)],
      ),
    ],
  );

  print(
    res.when(
      result: (result) => result.toString(),
      error: (error) => throw Exception(error),
    ),
  );

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('regester user transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}

Future<String> depositTokens(String amount) async {
  print('deposit Tokens.....');

  final res = await signerAccount.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName('withdraw'),
        calldata: [Felt.fromIntString(amount)],
      ),
    ],
  );

  print(
    res.when(
      result: (result) => result.toString(),
      error: (error) => throw Exception(error),
    ),
  );

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('Withdrawing Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}

Future<String> transferTokens(
  String amount,
  String senderAddress,
  String receiverAddress,
) async {
  print('Trasfering  Tokens.....');

  final res = await signerAccount.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName('withdraw'),
        calldata: [
          Felt.fromIntString(amount),
          Felt.fromHexString(senderAddress),
          Felt.fromHexString(receiverAddress),
        ],
      ),
    ],
  );

  print(
    res.when(
      result: (result) => result.toString(),
      error: (error) => throw Exception(error),
    ),
  );

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('Transfer Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}

Future<String> withdrawTokens(String amount) async {
  print('withdrawing Tokens.....');

  final res = await signerAccount.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: Felt.fromHexString(contractAddress),
        entryPointSelector: getSelectorByName('withdraw'),
        calldata: [Felt.fromIntString(amount)],
      ),
    ],
  );

  print(
    res.when(
      result: (result) => result.toString(),
      error: (error) => throw Exception(error),
    ),
  );

  final txHash = res.when(
    result: (result) => result.transaction_hash,
    error: (err) => throw Exception("Failed to execute"),
  );
  print('withdrawing Tokens transaction result:$txHash');
  return txHash;
  // return waitForAcceptance(transactionHash: txHash, provider: provider);
}
