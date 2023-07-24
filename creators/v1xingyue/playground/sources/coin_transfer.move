module playground::coin_action {

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use playground::fire_event::{do_fire};
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self,Coin};

    struct AdminCap has key{
        id:UID
    }

    struct MySuiHolder has key  {
        id: UID,
        hold: Balance<SUI>
    }

    fun init(ctx:&mut TxContext) {
        transfer::transfer(AdminCap{
            id:object::new(ctx)
        },tx_context::sender(ctx));
        transfer::share_object(
            MySuiHolder{
                id:object::new(ctx),
                hold:balance::zero<SUI>(),
            }
        );
    }

    public entry fun give_me_some_coin(holder:&mut MySuiHolder,c:&mut Coin<SUI>,amount:u64,ctx:&mut TxContext) {
        let need_coin = coin::split<SUI>(c,amount,ctx);
        let  b = coin::into_balance<SUI>(need_coin);
        balance::join(&mut holder.hold, b);
        do_fire(b"some coin has been given.",ctx);
    }

    public entry fun collect_coin(_:&AdminCap,holder:&mut MySuiHolder,ctx:&mut TxContext) {
        let amount = balance::value(&holder.hold);
        let coin = coin::take(&mut holder.hold, amount, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));
    }

}