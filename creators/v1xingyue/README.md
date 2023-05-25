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

- 关于对象权限传递 value , reference , mut reference 三种的区别

对于数据的操作权限是主机变化的。 

1. & object_type 对象只读
2. & mut object_type 可以修改对象
3. object_type 可以读取对象，修改对象，还可以 解构对象 

- 关于 object wrapping 

将一个 object 包装进一个object 内部。 包装完成后，将不在属于任何一个地址。如果需要使用该对象，需要打开盒子。
打开盒子的操作，可以添加若干限制，比如 地址限制，时间限制等。

具体可参看: [allow_mint.move](./playground/sources/allow_mint.move)

- 设计模式

1. cap 模式

用一个对象标记一个地址是否拥有某种操作的能力。

2. hot potato 模式

传递一个没有任何能力的 hot potato. 在处理过程中，必须处理掉(解构)。同时内部用来标记各种处理状态

(闪电贷) 在同一个合约操作中，必须同时完成 贷款 和 还款操作。 贷款完成后，生成一个 receipt 作为 hot potato.
然后，必须回调 repay 模式来解构掉。

这个模式有个前提，所有的 object 属性 都是private 属性。离开定义的module 就不能使用了。所以 ，传递的hot potato 必须经过定义的module 来处理，这个处理往往都是有代价的 (消耗coin).

3. witness 模式

witness 必须有drop 能力。进行某个操作，必须消耗一个 witness 对象。

4. id 模式

数据作为一个id 应用，将数据分离。


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

- 最简单RPC 调用 ，使用任何的http 模拟工具都可以完成

如下是一个 使用 curl 查询历史 event 的功能
具体的rpc 参数，可查阅 rpc 文档 : <https://docs.sui.io/sui-jsonrpc#suix_queryEvents>

```shell
curl -d '
    {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "suix_queryEvents",
        "params": [
            {
                "MoveModule": {
                    "package": "0x920fc84021c7ad4622f4fcbde511b0344951b43dfa9cc639588e3d2bcefa6181",
                    "module": "allow_mint"
                }
            }
        ]
    }
' -H 'Content-Type: application/json' https://fullnode.devnet.sui.io:443
```

- 关于 FT 同质化代币

1. 调用 coin::create_currency 生成两个对象 ， 一个 cap ，一个 metadata。
   metadata 的处理一般会 share 任何人可以更改，或者 freeze 固定到链上
2. 谨记 : cap 一定不能share，否则你的 coin将被任何人，任何地址mint。
3. cap 可以转为 supply, 作为一个store对象存储到任何object 内部。比如 封装到自己module 内部的MySupply。mint的时候传递。谨记: 未封装的 supply 同样不能share.
4. 关于FT 代币的上限，默认创建的代币mint 没有上限。或者说 上限是 u64 的最大值。
5. 如果需要限制一个FT 的 mint 和上限，则需要封账supply 在自己的mint 的时候完成限制调用。

综合 cap 模式 实现了一个 限制mint 的功能。 [limitcoin.move](./limitcoin)

## 学习成果

- [sui开发脚手架](https://github.com/v1xingyue/scaffold-sui)
- [sui todo](https://github.com/v1xingyue/sui-todo)

## Idea想法
