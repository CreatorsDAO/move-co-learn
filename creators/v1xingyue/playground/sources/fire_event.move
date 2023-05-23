module playground::fire_event {
    
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    #[test_only]
    use sui::test_scenario::{Self,ctx};

    struct MyEvent has copy,drop {
        address:address,
        msg: vector<u8>
    }

    fun init(ctx:&mut TxContext) {
        event::emit(MyEvent{
            address:tx_context::sender(ctx),
            msg: b"hello event"
        });
    }

    public fun do_fire(msg: vector<u8>, ctx:&mut TxContext){
        event::emit(MyEvent{
            address:tx_context::sender(ctx),
            msg: msg
        });
    }

    #[test]
    public fun event_test(){
        let addr1 = @0xA;
        let scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            do_fire(b"hello event test",ctx(scenario));
        };
        test_scenario::end(scenario_val);
    }

}
