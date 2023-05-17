# 一些简单有用的脚本 (目前主要针对快速调试sui应用)

建议安装 [jq](https://stedolan.github.io/jq/) , 配合 --json 使用。

## ls.sh

查看当前账户的objects, 可以根据 查看条件不同，适度修改

## move_to.sh

转移当前账户的object

## pub.sh 

最有用的一个脚本，可以快速发布当前模块,需要 第一个 gas 对象有足够的 gas

## call.sh 

调用脚本， 