## 3.1.1 Sui FT 视频讲解

https://youtu.be/wgMpvOiMOYo

### FT 课程资料

1. `_1_MyUSDT.move`

```rust
module coin_ex::MyUSDT {
    use sui::coin;
    use sui::tx_context;
    use std::option;
    use sui::transfer;
    use sui::tx_context::sender;

    // witness
    struct MYUSDT has drop { }

    fun init(witness: MYUSDT, ctx: &mut tx_context::TxContext){
        let (cap, metadata)=  coin::create_currency(
            witness,
            8,
            b"MyUSDT",
            b"MyUSDT",
            b"This is My USDT",
            option::none(),
            ctx,
        );
        transfer::public_share_object(metadata);
        transfer::public_transfer(cap,sender(ctx));
    }

    #[test_only]
    public fun init_4_test(ctx: &mut tx_context::TxContext){
        init(MYUSDT{}, ctx);
    }

}
```

2. `_2_NoMetadata_MyUSDT.move`

```rust
module coin_ex::MyUSDT_2 {
    use sui::tx_context;
    use sui::transfer;
    use sui::tx_context::sender;
    use sui::balance;
    use sui::coin;
    use sui::object::UID;
    use sui::object;

    // witness
    struct MYUSDT_2 has drop { }

    struct MySupply has key,store{
        id: UID,
        supply: balance::Supply<MYUSDT_2>
    }

    struct MYUSDC has drop{}
    fun init(witness: MYUSDT_2, ctx: &mut tx_context::TxContext){
        let supply = balance::create_supply(witness);
        transfer::public_transfer(MySupply{
            id: object::new(ctx),
            supply
        },sender(ctx));
    }

    public entry fun mint(supply:&mut MySupply,value: u64,ctx: &mut tx_context::TxContext){
        let balance = balance::increase_supply(&mut supply.supply,value);
        let coin = coin::from_balance(balance, ctx);
        transfer::public_transfer(coin, sender(ctx));
    }

    #[test_only]
    public fun init_4_test(ctx: &mut tx_context::TxContext){
        init(MYUSDT_2{}, ctx);
    }
}
```

3. `_3_Shared_MyUSDT.move`

```rust
module coin_ex::Shared_MyUSDT {
    use sui::tx_context;
    use sui::coin;
    use std::option;
    use sui::transfer;

    // witness
    struct SHARED_MYUSDT has drop { }

    fun init(witness: SHARED_MYUSDT, ctx: &mut tx_context::TxContext){
        let (cap, metadata)=  coin::create_currency(
            witness,
            8,
            b"sMyUSDT",
            b"sMyUSDT",
            b"This is My shared USDT",
            option::none(),
            ctx,
        );
        transfer::public_share_object(metadata);
        transfer::public_share_object(cap);
    }

    #[test_only]
    public fun init_4_test(ctx: &mut tx_context::TxContext){
        init(SHARED_MYUSDT{}, ctx);
    }
}
```

4. `_4_Unwrap_MyUSDT.move`

```rust
module coin_ex::UMYUSDT {
    use sui::tx_context;
    use sui::balance;
    use sui::tx_context::sender;
    use sui::transfer;
    use sui::coin;
    use std::option;
    use sui::object::UID;
    use sui::object;

    struct UMYUSDT has drop { }

    struct MySupply has key,store{
        id: UID,
        supply: balance::Supply<UMYUSDT>
    }

    fun init(witness: UMYUSDT, ctx: &mut tx_context::TxContext){
        let (cap, metadata)=  coin::create_currency(
            witness,
            8,
            b"UMYUSDT",
            b"UMYUSDT",
            b"This is My Unwarp USDT",
            option::none(),
            ctx,
        );
        transfer::public_share_object(metadata);
        let supply = coin::treasury_into_supply(cap);
        transfer::public_transfer(MySupply{
            id: object::new(ctx),
            supply
        },sender(ctx));
    }

    public entry fun mint(supply:&mut MySupply,value: u64,ctx: &mut tx_context::TxContext){
        let balance = balance::increase_supply(&mut supply.supply,value);
        let coin = coin::from_balance(balance, ctx);
        transfer::public_transfer(coin, sender(ctx));
    }

    #[test_only]
    public fun init_4_test(ctx: &mut tx_context::TxContext){
        init(UMYUSDT{}, ctx);
    }
}
```

### FT 课后作业

1. **创建一个有mint记录的代币水龙头**

> （创建一个自定义的 struct 保存 cap ，并提供 mint 接口，并记录 mint 用户的地址以及数量）

2. **尝试可以让任何人 mint 支持泛型的代币 如: LP<USDT,USDC>**

> （使用 no metadata 可以实现)

------

## 3.1.2 Sui NFT 视频讲解

https://youtu.be/WkQT8dtL35o

### NFT 课程资料

```rust
nft.move
module nft::my_nft {
    use sui::tx_context::{sender, TxContext};
    use std::string::{utf8, String};
    use sui::transfer::{Self, public_transfer};
    use sui::object::{Self, UID};
    use sui::package;
    use sui::display;

    struct MyNFT has key, store {
        id: UID,
        name: String,
        image_url: String
    }

    /// One-Time-Witness for the module.
    struct MY_NFT has drop {}

    fun init(otw: MY_NFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{image_url}"),
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<MyNFT>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));
    }

    public entry fun mint(ctx: &mut TxContext) {
        let name = utf8(b"my_nft");
        let image_url = utf8(b"<https://ipfs.io/ipfs/QmPHxBhZpXRTCF2vdqCmDti6abpkQmViPAQqfrtXpB7jvM?filename=cat_test_sui.jpeg>");
        let nft = MyNFT {
            id: object::new(ctx),
            name,
            image_url
        };
        public_transfer(nft, sender(ctx));
    }
}
```