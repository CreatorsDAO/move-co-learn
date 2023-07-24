# 0x01 配置开发环境

## 安装 Sui 二进制文件

### 本地安装 Sui 二进制文件（安装选择一）

[参考页面](https://docs.sui.io/build/install#install-sui-binaries)

1. [安装依赖](https://docs.sui.io/build/install#prerequisites) (取决于操作系统)

   [Rust备选安装方法](https://www.cnblogs.com/hustcpp/p/12341098.html)

   [Homebrew备选安装方法](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)

   [推荐Rust入门课](https://www.bilibili.com/video/BV1hp4y1k7SV)

2. 安装 Sui 二进制文件

   1. cargo install 直接下载 sui 二进制文件。下载位置位于 `$HOME/.cargo/bin/sui`

      ```bash
      cargo install --locked --git <https://github.com/MystenLabs/sui.git> --tag sui-v1.0.0 sui
      ```

   2. clone项目之后进行编译

      ```bash
      # 二进制文件出现在 sui/target/release 下，
      # 这种方式可以下载更多有用的二进制文件(比如: sui-test-validator)，
      # 并且方便在本地阅读 **framework** 源码。
      
      git clone <https://github.com/MystenLabs/sui.git>
      
      cd sui/
      
      git checkout sui-v1.0.0-release
      
      cargo build --release
      ```

3. 检验 binaries 是否安装成功:

   ```bash
   sui --version
   ```

   如果 sui binaries 安装成功，你将在终端看到版本信息。

### 使用预先安装有 Sui 二进制文件 的 Docker 镜像（安装选择二）

1. [安装 Docker](https://docs.docker.com/get-docker/)

2. Pull 为 Sui Move 导论课预制的 Docker 镜像

   ```bash
   docker pull hyd628/sui-move-intro-course:latest
   ```

3. 启动并进入 Docker 容器的 shell:

   ```bash
   docker run --entrypoint /bin/sh -itd hyd628/sui-move-intro-course:latest docker exec -it <container ID> bash
   ```

## 为 VS Code 配置 Move Analyzer 插件

1. 从 VS Marketplace 安装 [Move Analyzer 插件](https://marketplace.visualstudio.com/items?itemName=move.move-analyzer)

2. 配置与 Sui 格式的钱包地址兼容:

   ```bash
   cargo install --git <https://github.com/move-language/move> move-analyzer --branch sui-move --features "address32"
   ```

## Sui CLI 基础用法

[参考页面](https://docs.sui.io/build/cli-client)

### 管理网络

- 切换网络: `sui client switch --env [network alias]`
- 默认网络别名:
  - 本地网 localnet: http://0.0.0.0:9000
  - 开发网 devnet: https://fullnode.devnet.sui.io:443
- 列出当前所有网络别名: `sui client envs`
- 添加新的网络别名: `sui client new-env --alias <ALIAS> --rpc <RPC>`

```bash
# 添加主网rpc到本地cli环境
sui client new-env --alias mainnet --rpc <https://sui-mainnet.nodeinfra.com:443>

# 添加本地网rpc到本地cli环境
sui client new-env --alias localnet --rpc <http://127.0.0.1:9000>
```

### 查询启用地址和 Gas Objects

- 查询当前保存了密钥的地址: `sui client addresses`
- 查询当前启用的地址: `sui client active-address`
- 列出所拥有的 gas objects: `sui client gas`

## 获得开发网 Devnet 的 Sui Tokens

1. [加入 Sui Discord](https://discord.gg/sui)
2. 完成身份验证步骤
3. 进入 **#devnet-faucet** 频道
4. 输入 `!faucet <WALLET ADDRESS>`

如果使用Discord不方便或faucet故障，可以直接在终端输入指令

```bash
curl --location --request POST '<https://faucet.devnet.sui.io/gas>' \\
--header 'Content-Type: application/json' \\
--data-raw '{"FixedAmountRequest":{"recipient":"<WALLET ADDRESS>"}}'
```

## 获得测试网 Testnet 的 Sui Tokens

1. [加入 Sui Discord](https://discord.gg/sui)
2. 完成身份验证步骤
3. 进入 **#testnet-faucet** 频道
4. 输入 `!faucet <WALLET ADDRESS>`

# 0x02 Support Links

[sui-move-intro-course/1_set_up_environment.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-one/lessons/1_set_up_environment.md)

[sui-move-intro-course-zh/unit-one at main · RandyPen/sui-move-intro-course-zh](https://github.com/RandyPen/sui-move-intro-course-zh/tree/main/unit-one)

# 0x03 作业

1. 搭建本地环境
2. 配置cli网络
3. 创建新账户
4. 领取测试token
5. 查询gas余额