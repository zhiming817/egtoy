/**
 * Solana MCP Tutorial
 * 
 * This file demonstrates how to create a Model Context Protocol (MCP) server
 * that interacts with the Solana devnet to check SOL balances.
 */

// Import necessary dependencies
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { Connection, PublicKey, LAMPORTS_PER_SOL } from "@solana/web3.js";
import fs from 'fs';
import path from 'path';
import os from 'os';

// 日志文件路径 - 使用用户临时目录，确保有写入权限
const LOG_FILE = path.join(os.tmpdir(), 'solana-mcp-server.log');

/**
 * 记录日志到本地文件
 * @param level 日志级别
 * @param message 日志消息
 * @param data 附加数据
 */
function logToFile(level: LogLevel, message: string, data?: any) {
  const timestamp = new Date().toISOString();
  let logEntry = `[${timestamp}] [${level}] ${message}`;
  
  if (data) {
    logEntry += `\n${typeof data === 'object' ? JSON.stringify(data, null, 2) : data}`;
  }
  
  logEntry += '\n';
  
  // 写入日志文件（追加模式）
  fs.appendFileSync(LOG_FILE, logEntry);
  
  // 同时输出到控制台
  console.error(logEntry);
}
// 日志级别
enum LogLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR'
}

interface BalanceResult {
  success: boolean;
  balance: number;
  error: string | null;
}

/**
 * 查询 Solana 地址的 SOL 余额，带有重试机制
 * @param connection Solana 网络连接实例
 * @param address 要查询的 Solana 地址
 * @param retries 重试次数
 * @returns 格式化的余额信息
 */
export async function getSolanaBalance(
  connection: Connection, 
  address: string,
  retries = 3
): Promise<BalanceResult> {
  for (let i = 0; i < retries; i++) {
    try {
      // 创建公钥对象
      const publicKey = new PublicKey(address);
      
      // 查询余额
      const balance = await connection.getBalance(publicKey);

      // 返回格式化的查询结果
      return {
        success: true,
        balance: balance / LAMPORTS_PER_SOL,
        error: null
      };
    } catch (error) {
      // 如果是最后一次重试，则返回错误
      if (i === retries - 1) {
        return {
          success: false,
          balance: 0,
          error: error instanceof Error ? error.message : String(error)
        };
      }
      // 否则等待后重试
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }

  // 兜底返回
  return {
    success: false,
    balance: 0,
    error: '查询余额失败：超过最大重试次数'
  };
}

// Create a connection to Solana devnet
 const RPC_ENDPOINT = "https://crimson-dimensional-field.solana-devnet.quiknode.pro/4d9178b804f1a135bd98eb7d54a25969cb262f1e/";

const connection = new Connection(RPC_ENDPOINT, {
    commitment: "confirmed",
    confirmTransactionInitialTimeout: 60000, // 60秒超时
  });

// Initialize the MCP server with a name, version, and capabilities
const server = new McpServer({
    name: "solana-devnet",
    version: "0.0.1",
    capabilities: ["get-sol-balance"]
});

// Define a tool that gets the SOL balance for a given address
server.tool(
    "get-sol-balance",
    "query my wallet balance",
    {
        //address: z.string().describe("需要查询的 Solana 地址"),
    },
    async ({  }) => {
        const address ="EQKsPeerwacq5L2kW7qPAjqnJMYhL7ousMY1HKsc219p";
        // 查询余额
        const result = await getSolanaBalance(connection, address);

        // 返回查询结果
        if (result.success) {
            logToFile(LogLevel.INFO, `余额查询成功，发送响应`, { address, balance: result.balance });
            return {
                content: [
                    {
                        type: "text",
                        text: `your wallet balance is：${result.balance} SOL`,
                    },
                ],
            };
        } else {
            logToFile(LogLevel.ERROR, `余额查询失败，发送错误响应`, { address, error: result.error });
            return {
                content: [
                    {
                        type: "text",
                        text: `query file,i am sorry! the reason is：${result.error}`,
                    },
                ],
            };
        }
    }
);

// Export server instance for testing
export { server };

/**
 * Main function to start the MCP server
 * Uses stdio for communication with LLM clients
 */
async function main() {
    // 创建日志文件（如果不存在）
    try {
        // 确保日志目录存在和可写
        fs.writeFileSync(LOG_FILE, `[${new Date().toISOString()}] [INFO] ========== MCP 服务器启动 ==========\n`, { flag: 'a' });
        logToFile(LogLevel.INFO, `日志系统初始化成功，日志将写入: ${LOG_FILE}`);
    } catch (error) {
        console.error(`无法写入日志文件: ${error}`);
        console.error('将继续运行但不记录日志到文件');
    }
    
    // Create a transport layer using standard input/output
    const transport = new StdioServerTransport();
    
    // Connect the server to the transport
    await server.connect(transport);
    
    console.log("Solana Devnet MCP Server running on stdio");
}

// Start the server and handle any fatal errors
main().catch((error) => {
    console.error("Fatal error in main():", error);
    process.exit(1);
});

