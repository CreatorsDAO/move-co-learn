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

如果限制一个资源不可以转移，那么只给该资源 key 属性即可。

```rust
struct AdminCap has key { id: UID }
```

- 

- 学习move基本语法

## 学习成果

- [sui开发脚手架](https://github.com/v1xingyue/scaffold-sui)
- [sui todo](https://github.com/v1xingyue/sui-todo)

## Idea想法
