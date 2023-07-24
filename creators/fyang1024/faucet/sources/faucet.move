module faucet::paper_coin {
    use sui::tx_context::{sender, TxContext};
    use sui::coin;
    use sui::object::{Self, UID};
    use std::option;
    use sui::transfer;
    use sui::clock::{Self, Clock};
    use sui::table::{Self, Table};

    struct PAPER_COIN has drop {}

    struct MintRecord has store {
        count: u64,
        minted_amount: u64,
        last_mint_at: u64
    }

    struct PaperCoinCap has key, store {
        id: UID,
        cap: coin::TreasuryCap<PAPER_COIN>,
        records: Table<address, MintRecord>
    }

    fun init(witness: PAPER_COIN, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            8,
            b"PaperCoin",
            b"PaperCoin",
            b"This is PaperCoin",
            option::none(),
            ctx
        );

        let paperCoinCap = PaperCoinCap {
            id: object::new(ctx),
            cap: treasury,
            records: table::new<address, MintRecord>(ctx)
        };
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(paperCoinCap);
    }

    public entry fun mint(
        cap: &mut PaperCoinCap,
        value: u64,
        clock: &Clock,
        ctx: &mut TxContext
    ) {
        let coin = coin::mint(&mut cap.cap, value, ctx);
        transfer::public_transfer(coin, sender(ctx));

        let records = &mut cap.records;
        if (!table::contains(records, sender(ctx))){
            table::add(
                records,
                sender(ctx),
                MintRecord {
                    count: 0,
                    minted_amount: value,
                    last_mint_at: clock::timestamp_ms(clock)/1000
                },
            )
        };

        let mintRecord = table::borrow_mut(records, sender(ctx));

        mintRecord.count = mintRecord.count + 1;
        mintRecord.minted_amount = mintRecord.minted_amount + value;
        mintRecord.last_mint_at = clock::timestamp_ms(clock)/1000
    }
}