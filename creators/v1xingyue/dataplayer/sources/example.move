module dataplayer::example {

    use sui::object::{Self, UID,ID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::vector::{Self};

    const EDreamerInClass:u64 = 1;
    const ENotInClass:u64 = 2;

    struct Class has key,store {
        id:UID,
        names:vector<vector<u8>>,
        dreamers:vector<ID>
    }

    struct Dreamer has key,store  {
        id:UID,
        name:vector<u8>,
        age: u8,
    }

    fun init(ctx:&mut TxContext){
        transfer::share_object(Class{
            id:object::new(ctx),
            names:vector::empty<vector<u8>>(),
            dreamers:vector::empty<ID>()
        });
    }

    public fun make_dreamer(name:vector<u8>,age:u8,ctx:&mut TxContext): Dreamer {
        Dreamer{
                id: object::new(ctx),
                name,
                age
        }
    }

    public fun make_class(ctx:&mut TxContext): Class {
        Class{
                id: object::new(ctx),
                names:vector::empty<vector<u8>>(),
                dreamers:vector::empty<ID>()
        }
    }

    public fun class_mut_dreamers(c:&mut Class):&mut vector<ID>{
        &mut c.dreamers
    }

    public fun class_dreamers(c:&Class):&vector<ID>{
        &c.dreamers
    }

    entry fun make_dreamer_join(c:&mut Class,name:vector<u8>,age:u8,ctx:&mut TxContext){
        assert!(!vector::contains(&c.names,&name),EDreamerInClass);
        let dreamer = Dreamer{
            id:object::new(ctx),
            name,
            age
        };
        vector::push_back(&mut c.names,name);
        vector::push_back(&mut c.dreamers,object::id(&dreamer));
        transfer::transfer(dreamer,tx_context::sender(ctx));
    }

    /*
    entry fun leave_class(c:&mut Class,me:Dreamer,_ctx:&mut TxContext){
        let me_id = object::id(&me);
        assert!(vector::contains(&c.dreamers,&me_id),ENotInClass);
        let Dreamer{id,name:_,age:_} = me;
    }
    */

    

    

}