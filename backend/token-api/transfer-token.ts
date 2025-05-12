import 'dotenv/config'; // 确保这行在最上面，以加载 .env 文件
import express, { Request, Response } from 'express'; // 导入 express
import { 
  createTransferInstruction,
  getOrCreateAssociatedTokenAccount,
  getAccount,
  getAssociatedTokenAddress,
  ASSOCIATED_TOKEN_PROGRAM_ID,
  getMint
} from '@solana/spl-token';
import {
  Connection,
  Keypair,
  PublicKey,
  sendAndConfirmTransaction,
  Transaction,
  Commitment // 明确导入 Commitment 类型
} from '@solana/web3.js';
import { getKeypairFromFile } from '@solana-developers/helpers';

// --- 从 process.env 读取全局配置 ---
const RPC_ENDPOINT = process.env.RPC_ENDPOINT;
const TOKEN_2022_PROGRAM_ID_STRING = process.env.TOKEN_2022_PROGRAM_ID_STRING;
const SENDER_KEYPAIR_PATH = process.env.SENDER_KEYPAIR_PATH;
const MINT_ADDRESS_STRING = process.env.MINT_ADDRESS_STRING; // Mint地址通常是固定的
const TRANSACTION_CONFIRMATION_STATUS = process.env.TRANSACTION_CONFIRMATION_STATUS as Commitment | undefined;
const SLEEP_DURATION_MS_STRING = process.env.SLEEP_DURATION_MS;
const API_PORT_STRING = process.env.API_PORT;

// 校验必要的全局环境变量是否存在
if (!RPC_ENDPOINT || !TOKEN_2022_PROGRAM_ID_STRING || !SENDER_KEYPAIR_PATH || !MINT_ADDRESS_STRING) {
  throw new Error("错误：RPC_ENDPOINT, TOKEN_2022_PROGRAM_ID_STRING, SENDER_KEYPAIR_PATH, 或 MINT_ADDRESS_STRING 未在 .env 文件中设置。");
}

const TOKEN_2022_PROGRAM_ID = new PublicKey(TOKEN_2022_PROGRAM_ID_STRING);
const MINT_ADDRESS = new PublicKey(MINT_ADDRESS_STRING);
const SLEEP_DURATION_MS = SLEEP_DURATION_MS_STRING ? parseInt(SLEEP_DURATION_MS_STRING, 10) : 3000;
const API_PORT = API_PORT_STRING ? parseInt(API_PORT_STRING, 10) : 3000;

// 辅助函数：添加延迟
const sleep = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

/**
 * 封装的代币转账函数
 * @param receiverAddressString 接收者的钱包地址 (字符串)
 * @param wholeTokensToTransfer 要转账的“整数”代币数量
 * @returns Promise<{signature: string}> 包含交易签名的对象
 * @throws Error 如果发生错误
 */
async function transferTokens(receiverAddressString: string, wholeTokensToTransfer: number): Promise<{ signature: string }> {
  if (!receiverAddressString || typeof wholeTokensToTransfer !== 'number' || wholeTokensToTransfer <= 0) {
    throw new Error("错误：无效的接收者地址或转账金额。");
  }

  const RECEIVER_ADDRESS = new PublicKey(receiverAddressString);

  // 加载发送者的密钥对
  const sender = await getKeypairFromFile(SENDER_KEYPAIR_PATH);
  console.log("发送者地址:", sender.publicKey.toBase58());
  
  // 创建连接
  const connection = new Connection(RPC_ENDPOINT, TRANSACTION_CONFIRMATION_STATUS || 'confirmed');

  console.log("代币 mint地址:", MINT_ADDRESS.toBase58());
  console.log("目标接收者地址:", RECEIVER_ADDRESS.toBase58());
  console.log("计划转账数量 (整数单位):", wholeTokensToTransfer);

  // 获取代币信息，特别是小数位数 (decimals)
  console.log("正在获取代币信息 (decimals)...");
  const mintInfo = await getMint(
      connection,
      MINT_ADDRESS,
      TRANSACTION_CONFIRMATION_STATUS || 'confirmed',
      TOKEN_2022_PROGRAM_ID // 假设此代币是 Token-2022 标准
  );
  const decimals = mintInfo.decimals;
  console.log(`代币的小数位数为: ${decimals}`);

  // 获取发送者的关联代币账户地址
  console.log("获取发送者关联代币账户地址 (Token-2022)...");
  const senderTokenAccountAddress = await getAssociatedTokenAddress(
    MINT_ADDRESS,
    sender.publicKey,
    false, 
    TOKEN_2022_PROGRAM_ID, 
    ASSOCIATED_TOKEN_PROGRAM_ID
  );
  console.log("发送者代币账户地址:", senderTokenAccountAddress.toBase58());
  
  // 获取发送者代币账户信息
  console.log("获取发送者代币账户信息 (Token-2022)...");
  const tokenAccountInfo = await getAccount(
    connection, 
    senderTokenAccountAddress, 
    TRANSACTION_CONFIRMATION_STATUS || 'confirmed', 
    TOKEN_2022_PROGRAM_ID
  );
  console.log(`发送者代币余额 (原始单位): ${tokenAccountInfo.amount.toString()}`);
  console.log(`发送者代币余额 (换算后): ${Number(tokenAccountInfo.amount) / (10 ** decimals)}`);
    
  // 根据小数位数计算实际的 amount (最小单位数量)
  const amount = BigInt(wholeTokensToTransfer) * (BigInt(10) ** BigInt(decimals));
  console.log(`准备转账 ${wholeTokensToTransfer} 个完整代币单位 (即 ${amount.toString()} 个最小单位)`);

  // 确保余额充足
  if (tokenAccountInfo.amount < amount) {
    throw new Error(
      `发送者的代币余额不足。需要转账 ${amount.toString()} 个最小单位, 但只有 ${tokenAccountInfo.amount.toString()} 个。`
    );
  }
    
  console.log("正在为接收者创建/获取关联令牌账户 (Token-2022)...");
  const receiverTokenAccount = await getOrCreateAssociatedTokenAccount(
    connection,
    sender, 
    MINT_ADDRESS,
    RECEIVER_ADDRESS,
    false, 
    TRANSACTION_CONFIRMATION_STATUS || 'confirmed', 
    undefined, 
    TOKEN_2022_PROGRAM_ID, 
    ASSOCIATED_TOKEN_PROGRAM_ID
  );
  console.log("接收者令牌账户:", receiverTokenAccount.address.toBase58());

  // 创建转账指令
  const transferInstruction = createTransferInstruction(
    senderTokenAccountAddress,
    receiverTokenAccount.address,
    sender.publicKey,
    amount,
    [],
    TOKEN_2022_PROGRAM_ID
  );

  const transaction = new Transaction().add(transferInstruction);
    
  console.log("发送交易...");
  const signature = await sendAndConfirmTransaction(connection, transaction, [sender]);
  console.log(`交易已确认! 签名: ${signature}`);
  console.log(`您可以在浏览器中查看此交易: https://explorer.solana.com/tx/${signature}?cluster=devnet`);

  console.log(`等待区块链状态更新 (${SLEEP_DURATION_MS / 1000}秒)...`);
  await sleep(SLEEP_DURATION_MS); 
    
  const receiverBalance = await getAccount(
    connection, 
    receiverTokenAccount.address, 
    TRANSACTION_CONFIRMATION_STATUS || 'confirmed', 
    TOKEN_2022_PROGRAM_ID
  );
  console.log(`接收者的代币余额 (原始单位): ${receiverBalance.amount.toString()}`);
  console.log(`接收者的代币余额 (换算后): ${Number(receiverBalance.amount) / (10 ** decimals)}`);
  
  return { signature }; // 成功时返回交易签名
}

// --- Web API 设置 ---
const app = express();
app.use(express.json()); // 用于解析 JSON 请求体

// API 端点
app.post('/api/transfer', async (req: Request, res: Response) => {
  const { receiverAddress, amountToTransfer } = req.body;

  if (!receiverAddress || typeof amountToTransfer !== 'number' || amountToTransfer <= 0) {
    return res.status(400).json({ error: '无效的请求参数: 请提供 receiverAddress (string) 和 amountToTransfer (number > 0)。' });
  }

  console.log(`收到 API 请求: 转账 ${amountToTransfer} 到 ${receiverAddress}`);

  try {
    const result = await transferTokens(receiverAddress, amountToTransfer);
    console.log("API 转账成功:", result.signature);
    return res.status(200).json({ success: true, signature: result.signature, message: '转账成功发起并确认。' });
  } catch (error) {
    console.error("API 转账失败:", error);
    let errorMessage = '转账过程中发生未知错误。';
    let statusCode = 500;

    if (error instanceof Error) {
        errorMessage = error.message;
        if (error.message.includes("无效的接收者地址或转账金额")) {
            statusCode = 400;
        } else if (error.message.includes("发送者的代币余额不足")) {
            statusCode = 400; // 或者 422 Unprocessable Entity
        } else if (error.name === 'TokenAccountNotFoundError') {
            errorMessage = "错误: 相关的代币账户未找到。";
            statusCode = 404;
        } else if (error.name === 'TokenInvalidAccountOwnerError') {
            errorMessage = "错误: 代币账户所有者无效或程序ID不匹配。";
            statusCode = 400; // 或者 500，取决于具体情况
        }
    }
    return res.status(statusCode).json({ success: false, error: errorMessage });
  }
});

// --- 主执行逻辑 (启动服务器) ---
async function main() {
  app.listen(API_PORT, () => {
    console.log(`代币转账 API 服务器正在监听端口 ${API_PORT}`);
    console.log(`可以通过 POST 请求到 http://localhost:${API_PORT}/api/transfer 来发起转账`);
    console.log(`请求体示例: { "receiverAddress": "接收者地址", "amountToTransfer": 数量 }`);
  });
}

main().catch(err => {
  console.error("主程序执行失败 (无法启动服务器):", err);
  process.exit(1); // 确保在启动失败时退出
});