module limitcoin::limitcoin {

    use sui::coin::{Self};
    use sui::tx_context;
    use std::option;
    use sui::transfer;
    use sui::balance;

    use sui::tx_context::sender;
    use sui::object::{Self, UID};

    use limitcoin::card::{Self,Card};

    struct MySupply has key,store{
        id: UID,
        supply: balance::Supply<LIMITCOIN>
    }

    // witness
    struct LIMITCOIN has drop {}

    fun init(witness: LIMITCOIN, ctx: &mut tx_context::TxContext){
        let (cap, metadata)=  coin::create_currency(
            witness,
            4,
            b"LIMITCOIN",
            b"LIMITCOIN",
            b"This is Limited Token",
            option::none(),
            ctx,
        );
        transfer::public_share_object(metadata);
        let supply = coin::treasury_into_supply(cap);
        transfer::public_share_object(MySupply{
            id: object::new(ctx),
            supply
        });
    }

    public entry fun mint(card:&mut Card, supply:&mut MySupply,value: u64,ctx: &mut tx_context::TxContext){
        card::add_count(card);
        
        let balance = balance::increase_supply(&mut supply.supply,value);
        let coin = coin::from_balance(balance, ctx);
        transfer::public_transfer(coin, sender(ctx));
    }


}