module playground::coin_pool {

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::sui::{SUI};
    use sui::coin::{Self,Coin};
    use sui::balance::{Self,Balance};

    const E_NotEnough:u64 = 1;

    struct CoinPool has key {
        id: UID,
        balance: Balance<SUI>
    }

    entry fun make_pool(ctx:&mut TxContext){
        transfer::transfer(CoinPool{
            id:object::new(ctx),
            balance: balance::zero<SUI>()
        },tx_context::sender(ctx));
    }

    entry fun add_coin(c:&mut Coin<SUI>,amount:u64,pool: &mut CoinPool,ctx:&mut TxContext){
        let need_coin = coin::split<SUI>(c,amount,ctx);
        let  b = coin::into_balance<SUI>(need_coin);
        balance::join(&mut pool.balance, b);
    }

    entry fun withdraw_to_address(amount:u64,dst:address,pool: &mut CoinPool,ctx:&mut TxContext){
        let pool_amount  = balance::value(&pool.balance);
        assert!(pool_amount > amount,E_NotEnough);
        let coin = coin::take(&mut pool.balance, amount, ctx);
        transfer::public_transfer(coin, dst);
    }

}