module counter::counter{
    use sui::transfer;
    use sui::object::{Self,UID};
    use sui::tx_context::{Self,TxContext};

    struct Counter has key{
        id:UID,
        value:u64,
    }
    
    public entry fun getCounter(ctx: &mut TxContext){
        let sender = tx_context::sender(ctx);
        let counter = Counter{
            id:object::new(ctx),
            value:0
        };
        transfer::transfer(counter,sender);
    }

    public entry fun increment(counter:&mut Counter){
        counter.value = counter.value +1;
    }

    public entry fun setValue(counter:&mut Counter, value:u64){
        counter.value = value;
    }



}