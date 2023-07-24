module simple_nft::nft {
    use sui::tx_context::{sender, TxContext};
    use sui::object::{Self, ID, UID};
    use std::string::{utf8, String};
    use sui::url::{Self,Url};
    use sui::package;
    use sui::display;
    use sui::transfer::{Self, public_transfer};
    use sui::event;

    struct SimpleNFT has key, store {
        id: UID,
        name: String,
        image_url: Url
    }

    // one-time witness for this module
    struct NFT has drop {}

    // ===== Events =====

    struct NFTMinted has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        // The creator of the NFT
        creator: address,
        // The name of the NFT
        name: String
    }

    fun init(otw: NFT, ctx: &mut TxContext) {
        let keys = vector[utf8(b"name"), utf8(b"image_url")];
        let values = vector[utf8(b"{name}"), utf8(b"{image_url}")];

        let publisher = package::claim(otw, ctx);

        let display = display::new_with_fields<SimpleNFT>(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        public_transfer(publisher, sender(ctx));
        public_transfer(display, sender(ctx));
    }

    public entry fun mint(
        name: vector<u8>,
        image_url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = sender(ctx);
        let nft = SimpleNFT {
            id: object::new(ctx),
            name: utf8(name),
            image_url: url::new_unsafe_from_bytes(image_url)
        };
        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });
        public_transfer(nft, sender)
    }

    public entry fun burn(nft: SimpleNFT, _: &mut TxContext) {
        let SimpleNFT {
            id, name: _, image_url: _
        } = nft;
        object::delete(id)
    }

    public entry fun transfer(
        nft: SimpleNFT, recipient: address, _: &mut TxContext
    ) {
        public_transfer(nft, recipient)
    }

    public entry fun update_name(
        nft: &mut SimpleNFT,
        new_name: vector<u8>,
        _: &mut TxContext
    ) {
        nft.name = utf8(new_name)
    }

    public fun name(nft: &SimpleNFT): &String {
        &nft.name
    }

    public fun image_url(nft: &SimpleNFT): &Url {
        &nft.image_url
    }
}