module playground::allow_mint {

    const ENotAllowAddress: u64 = 1;

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    
    struct Item has store,key {
        id:UID,
        value:u64
    }

    struct Box has key {
        id:UID,
        item:Item,
        allow_address: address
    }

    public entry fun create_allow_box(value:u64,allow_address:address,ctx:&mut TxContext){
        let item = Item{
            id:object::new(ctx),
            value
        };
        transfer::transfer(
            Box{
                id:object::new(ctx),
                item,
                allow_address
            },tx_context::sender(ctx)
        )
    }

    public entry fun open_box(box:Box,ctx:&mut TxContext){
        assert!(box.allow_address == tx_context::sender(ctx),ENotAllowAddress);
        let Box{id,item,allow_address:_} = box;
        transfer::transfer(item,tx_context::sender(ctx));
        object::delete(id);
    }

}