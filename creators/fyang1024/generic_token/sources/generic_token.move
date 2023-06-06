module generic_token::gtoken {
    use sui::object::{Self, UID};
    use sui::balance;
    use sui::tx_context::{sender, TxContext};
    use sui::transfer;
    use sui::coin;

    struct MySupply<phantom CoinType: drop> has key, store {
        id: UID,
        supply: balance::Supply<CoinType>
    }

    public entry fun create<CoinType: drop>(coinType: CoinType, ctx: &mut TxContext) {
        let supply = balance::create_supply(coinType);
        transfer::public_share_object(MySupply{
            id: object::new(ctx),
            supply
        });
    }

    public entry fun mint<CoinType: drop>(
        supply:&mut MySupply<CoinType>,
        value: u64,
        ctx: &mut TxContext
    ){
        let balance = balance::increase_supply(&mut supply.supply,value);
        let coin = coin::from_balance(balance, ctx);
        transfer::public_transfer(coin, sender(ctx));
    }
}