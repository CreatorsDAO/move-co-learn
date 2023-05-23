# Creator 信息
## 个人介绍

Github ID: [fyang1024](https://github.com/fyang1024)

Sui 账号地址: 0xe0a15598b6b7b9a5170149288abac392223c1f332f58942e7b680d5f9cb1357d

(部分)自我认知: 资深码农，币圈老韭菜

## 学习日志

* 2023.05.08 ~ 2023.05.14 
  - 学习了第一周的课程，包括本地开发环境的搭建、Sui Move的基本语法、Sui Move的单元测试写法。
  - 阅读了部分官方文档，重点阅读了[programming-with-objects](https://docs.sui.io/build/programming-with-objects)部分。
  - 部署了第一课中的`HelloWorld`示例
  - 独立完成了第一课的课后作业`Counter`项目
  - 参与了第一周的Office Hour
* 2023.05.15 ~ 2023.05.21
  - 学习了第二周的课程，包括对象讲解、设计模式
  - 重读了官方文档[programming-with-objects](https://docs.sui.io/build/programming-with-objects)部分
  - 参与了uvd老师的直播课
  - 着手【组队项目】MoveFlow SDK on Sui
  - 参与了uvd老师的Office Hour

## 学习成果

* 2023.05.08 ~ 2023.05.14
    - 初步了解了Sui Move的`everything is object`概念
    - 初步理解了Sui中数据类型的四种能力：Copy, Drop, Key, Store
* 2023.05.15 ~ 2023.05.21
    - 初步理解了对象的三种所有权：私有、共享可变、共享不可变
    - 进一步理解Sui中数据类型的四种能力：Copy, Drop, Key, Store
    - 深入了解了Sui Move的三种函数参数传递方式(引用、可变饮用、值)的差别
    - 深入了解了One Time Witness和Hot Potato设计模式的原理和用途

## Idea想法

* 2023.05.08 ~ 2023.05.14
    - Sui Move的编程模型和Solidity差别巨大，相比而言，Sui Move的对象概念更加适合建模区块链上的资产
* 2023.05.15 ~ 2023.05.21
    - Sui Move的合约安全漏洞天然会比Solidity的合约漏洞要少，编程者必须时刻思考资产的所有权和访问权
    - Sui Move禁止Dynamic Dispatch，杜绝了Solidity合约经常出现的重入(Reentrancy)攻击漏洞