#[test_only]
module dataplayer::vector_test {

    use sui::test_scenario::{Self,ctx};
    use std::debug;

    use sui::object::{Self};
    use sui::transfer;
    use std::vector;
    
    use dataplayer::example::{Self};


    struct A has store,drop {
        value: u64
    }



    #[test]
    public fun test_vector(){
        let v:vector<u64> = vector::empty<u64>();
        let a:u64 = 10;
        while(a > 0 ) {
            vector::push_back(&mut v,a);
            a = a - 1;
        };


        let f:u64 = 20;

        let (exists,index) = vector::index_of(&v,&f);
        debug::print(&exists);
        debug::print(&index);

        let f:u64 = 5;

        let (exists,index) = vector::index_of(&v,&f);
        debug::print(&exists);
        debug::print(&index);

        debug::print(&v);
        let last = vector::length(&v) - 1;
        vector::swap(&mut v,index,last);
        debug::print(&v);

        let s = 3;
        while(s > 0 ) {
            let m = vector::pop_back(&mut v);
            debug::print(&m);
            s = s - 1;
        };
        
        debug::print(&v);

    }

    #[test]
    public fun test_vector_object(){

        let v:vector<A> = vector::empty<A>();
        let a:u64 = 10;
        while(a > 0 ) {
            vector::push_back(&mut v,A{
                value:a
            });
            a = a - 1;
        };

        debug::print(&v);

        let f:u64 = 3;
        let (exists,index) = vector::index_of(&v,&A{
            value: f
        });
        debug::print(&exists);
        debug::print(&index);

        debug::print(&v);
        let last = vector::length(&v) - 1;
        vector::swap(&mut v,index,last);
        debug::print(&v);

        let s = 3;
        while(s > 0 ) {
            let m = vector::pop_back(&mut v);
            debug::print(&m);
            s = s - 1;
        };
    }

    #[test]
    public fun test_get_id(){
        

        let addr1 = @0xA;
        let scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;

        {

            let d = example::make_dreamer(b"hello",128,ctx(scenario));
            let c = example::make_class(ctx(scenario));

            debug::print(&d);
            let x = object::id(&d);
            debug::print(&x);
            vector::push_back(example::class_mut_dreamers(&mut c),object::id(&d));
            let b = vector::contains(example::class_dreamers(&mut c),&x);
            debug::print(&b);

            transfer::public_transfer(d,addr1);
            transfer::public_transfer(c,addr1);

            
        };

        test_scenario::end(scenario_val);

    }
}