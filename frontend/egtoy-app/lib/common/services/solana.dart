import 'package:solana/solana.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class SolanaService extends GetxService {
  late final SolanaClient _client;

  SolanaService({bool devnet = true}) {
    final rpcUrl =
        devnet
            ? 'https://api.devnet.solana.com'
            : 'https://api.mainnet-beta.solana.com';
    final wsUrl =
        devnet
            ? 'wss://api.devnet.solana.com'
            : 'wss://api.mainnet-beta.solana.com';
    _client = SolanaClient(
      rpcUrl: Uri.parse(rpcUrl),
      websocketUrl: Uri.parse(wsUrl),
    );
  }

  // 获取账户余额
  Future<double> getBalance(String address) async {
    final pubKey = Ed25519HDPublicKey.fromBase58(address);
    final balance = await _client.rpcClient.getBalance(pubKey.toBase58());
    return balance.value / lamportsPerSol;
  }

  // 转账SOL
  Future<String> transferSol({
    required Wallet wallet,
    required String destination,
    required double amount,
  }) async {
    final destinationPubKey = Ed25519HDPublicKey.fromBase58(destination);

    final signature = await _client.transferLamports(
      source: wallet,
      destination: destinationPubKey,
      lamports: (amount * lamportsPerSol).toInt(),
    );

    return signature;
  }

  // 获取代币余额
  Future<double> getTokenBalance(String walletAddress, String tokenMint) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.devnet.solana.com'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'getTokenAccountsByOwner',
          'params': [
            walletAddress,
            {'mint': tokenMint},
            {'encoding': 'jsonParsed'},
          ],
        }),
      );

      final data = jsonDecode(response.body);
      if (data['result'] == null || data['result']['value'].isEmpty) {
        return 0.0;
      }

      final account = data['result']['value'][0];
      final amount =
          account['account']['data']['parsed']['info']['tokenAmount']['uiAmount'];
      return amount.toDouble();
    } catch (e) {
      print('直接RPC请求失败: $e');
      return 0.0;
    }
  }
}
