#[test_only]
module playground::hello_test {

    use std::debug;
    use sui::test_scenario::{Self,ctx};
    use sui::tx_context::{Self};
    use sui::object::{Self,UID};
    use sui::transfer::{Self};

    struct A has key {
        id: UID,
        value: u64
    }

    struct B has key {
        id: UID,
        aid: UID
    }

    struct Nocopy  {
        value: u64
    }

    fun get_nocoy() : Nocopy{
        let n = Nocopy{value:128};
        n
    }

    // fun do_something_with_nocopy(){
    //    // _ = get_nocoy();
    // }

    #[test]
    public fun test_my_hello(){
        let addr1 = @0xA;
        let addr2 = @0xB;

        let scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;

        {
            let a = A{
                id: object::new(ctx(scenario)),
                value: 128
            };
            debug::print(&b"0");
            debug::print(&a.id);
            transfer::transfer(a,addr1);
        };

        test_scenario::next_tx(scenario,addr1);
        {
            let object = test_scenario::take_from_sender<A>(scenario);
            object.value = 256;
            transfer::transfer(object,addr2);
        };

        test_scenario::next_tx(scenario,addr2);
        {
            let object = test_scenario::take_from_sender<A>(scenario);
            debug::print(&object.value);
            assert!(object.value == 256,0);
            transfer::transfer(object,addr2);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    public fun test_hello(){
        let addr1 = @0xA;
        let scenario = test_scenario::begin(addr1);
        let msg:vector<u8> = b"hello this is a test module";
        debug::print(&msg);
        debug::print(&(tx_context::sender(ctx(&mut scenario))));
        test_scenario::end(scenario);
    }  

}