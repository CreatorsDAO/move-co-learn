module dataplayer::hash_hidden {

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};  
    use std::vector::{Self};
    use std::bcs::{Self};
    use sui::hash::{blake2b256};
    use sui::hex::{decode};

    struct HiddenValue has key {
        id:UID,
        msg_hash:vector<u8>,
        msg_value: u64
    }

    entry fun write_hidden_value(msg_hex:vector<u8>,ctx:&mut TxContext){ 
        transfer::transfer(HiddenValue{
            id:object::new(ctx),
            msg_hash:decode(msg_hex),
            msg_value:0
        },tx_context::sender(ctx));
    }

    entry fun prove_value(v:&mut HiddenValue,value:u64,pass:vector<u8>,_:&mut TxContext){
        let m:vector<u8> = vector::empty<u8>();
        vector::append(&mut m,pass);
        vector::append(&mut m,bcs::to_bytes<u64>(&value));
        let a = blake2b256(&m);
        assert!(a == v.msg_hash,1);
        v.msg_value = value;
    }

    #[test]
    public fun test_hidden() {
        use sui::hash::{blake2b256};
        use std::debug;

        debug::print(&b"00000000000000000000000000000000000000000000");
        
        let msg:vector<u8> = vector::empty<u8>();
        vector::append(&mut msg,b"abcdefg");
        vector::append(&mut msg,bcs::to_bytes<u64>(&123456));
        let a = blake2b256(&msg);
        debug::print(&a);

        debug::print(&b"00000000000000000000000000000000000000000000");

    }

}