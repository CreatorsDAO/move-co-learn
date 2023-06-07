module limitcoin::card {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// An object that contains an arbitrary string
    struct Card has key, store {
        id: UID,
        mint_count: u64
    }

    public fun add_count(card:&mut Card) {
        card.mint_count = card.mint_count + 1
    }

    public fun card_count(card:&Card) : u64 {
        card.mint_count
    }

    public entry fun mint(ctx: &mut TxContext) {
        let object = Card {
            id: object::new(ctx),
            mint_count: 0
        };
        transfer::public_transfer(object, tx_context::sender(ctx));
    }

}