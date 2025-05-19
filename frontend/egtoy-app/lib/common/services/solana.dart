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
    String? memo,
  }) async {
    final destinationPubKey = Ed25519HDPublicKey.fromBase58(destination);

    final signature = await _client.transferLamports(
      source: wallet,
      destination: destinationPubKey,
      lamports: (amount * lamportsPerSol).toInt(),
      memo: memo,
    );

    return signature;
  }

  Future<String> transferSplToken({
    required Wallet sourceWallet, // 发送方钱包
    required String destinationAddress, // 接收方 Solana 地址 (不是代币账户地址)
    required String tokenMintAddress, // 代币的 Mint 地址
    required int amount, // 要发送的代币数量 (最小单位)
    int? decimals, // 代币的小数位数，如果为null，会尝试从mint地址获取
    String? memo,
  }) async {
    final destinationPubKey = Ed25519HDPublicKey.fromBase58(destinationAddress);
    final mintPubKey = Ed25519HDPublicKey.fromBase58(tokenMintAddress);

    // 如果未提供decimals，尝试从mint地址获取
    // final tokenDecimals =
    //     decimals ??
    //     await _client.rpcClient
    //         .getTokenSupply(mintPubKey.toBase58())
    //         .then((s) => s.value.decimals);

    // 注意：solana_dart 的 transferSplToken 方法期望 amount 是以代币的最小单位表示的。
    // 如果你的 amount 是以用户可读的单位（例如 1 EGT），你需要将其转换为最小单位。
    // 例如，如果 EGT 有 9 位小数，发送 1 EGT，则 amount 应为 1 * 10^9。
    // 这里假设传入的 amount 已经是最小单位。

    final signature = await _client.transferSplToken(
      owner: sourceWallet,
      destination: destinationPubKey, // 接收者的主账户地址
      mint: mintPubKey,
      amount: amount,
      tokenProgram: TokenProgramType.token2022Program,
      memo: memo,
    );

    return signature;
  }

  // 获取交易记录
  Future<List<dynamic>> getTransactionHistory(String address) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.devnet.solana.com'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'getConfirmedSignaturesForAddress2',
          'params': [
            address,
            {'limit': 10},
          ],
        }),
      );

      final data = jsonDecode(response.body);
      if (data['result'] == null) {
        return [];
      }
      return data['result'];
    } catch (e) {
      print('直接RPC请求失败: $e');
      return [];
    }
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
