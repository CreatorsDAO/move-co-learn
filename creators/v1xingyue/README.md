# Creator 信息

## 个人介绍

Github ID: [v1xingyue](https://github.com/v1xingyue)

Sui 账号地址: 0xc4d17bdea567268b50cb24c783ccafc678d468a0cfce0afb84313b163cb403ef

传统互联网公司的打杂开发者，技术栈比较混杂。Web3 爱好者。

## 学习日志

- sui 发布合约相关 (合约升级)

不知道大家注意没有使用sui发布合约后，会给当前地址转移一个  0x2::package::UpgradeCap 对象。
该对象标志了一个地址对该模块的更新的权限，即持有该对象的钱包地址才可以完成相应合约的升级。
该对象权限为 store, key。该权限可以转移。

* https://docs.sui.io/devnet/build/custom-upgrade-policy

- 对象权限相关

store 能力标记的是该资源能否做为其他对象的属性。如果一个struct 会作为另一个struct 的属性，那么必须有store 能力。
如果限制一个资源不可以转移，那么只给该资源 key 属性即可。

同时如果一个 object 具有 key store 属性，那么他将可以作为公共资产，放大转移的权限。
即 允许除自身以外的第三方(钱包,sui cli等) 转移对象所有权

```rust
// AdminCap 将只允许自身module 对其进行转移操作
struct AdminCap has key { id: UID }

// 将允许自身module和其他第三方对其进行转移操作
struct TransferCap has key,store { id: UID }

```

- 关于 object wrapping 

将一个 object 包装进一个object 内部。 包装完成后，将不在属于任何一个地址。如果需要使用该对象，需要打开盒子。
打开盒子的操作，可以添加若干限制，比如 地址限制，时间限制等。

具体可参看: [allow_mint.move](./playground/sources/allow_mint.move)

- dapp 开发相关

获取rpc 交互对象

```typescript

let connection = devnetConnection;
if(NETWORK === "mainnet"){
    connection = mainnetConnection;
}
const provider = new JsonRpcProvider(connection);
```

获取链上数据 getOwnedObjects
其中 filter 参数可以有多种变化,具体参看 getOwnedObjects 方法介绍

```typescript
const resp = await provider.getOwnedObjects({
    owner: address as string,
    filter:{
        StructType:`${SUI_PACKAGE}::post::Post`
    },
    options:{
        showType:true,
        showContent:true,
        showDisplay:true,
    }
});
```

- 学习move基本语法

## 学习成果

- [sui开发脚手架](https://github.com/v1xingyue/scaffold-sui)
- [sui todo](https://github.com/v1xingyue/sui-todo)

## Idea想法
