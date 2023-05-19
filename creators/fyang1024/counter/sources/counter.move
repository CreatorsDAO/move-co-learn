module counter::counter {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Counter has key, store {
        id: UID,
        value: u256
    }

    public entry fun create_counter(ctx: &mut TxContext) {
        let c = Counter { 
            id: object::new(ctx), 
            value: 0u256
        };
        transfer::transfer(c, tx_context::sender(ctx));
    }

    public entry fun increment(c: &mut Counter) {
        c.value = c.value + 1;
    }

    public entry fun decrement(c: &mut Counter) {
        c.value = c.value - 1;
    }
}