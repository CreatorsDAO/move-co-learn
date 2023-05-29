module  blog::page {

    use std::string::{String};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::clock::{Self,Clock};

    struct Page has key {
        id: UID,
        name: String,
        display: String,
        create_time: u64
    }

    public entry fun create_page(name: String, display: String, now: &Clock,ctx: &mut TxContext) {
        transfer::transfer(Page{
            id:object::new(ctx),
            name,
            display,
            create_time:clock::timestamp_ms(now)
        },tx_context::sender(ctx));
    }

    public entry fun update_page(name: String, display: String , page: &mut Page, _: &mut TxContext){
        page.name = name;
        page.display = display;
    }

    public entry fun delete_page(page:Page, _: &mut TxContext){
        let Page{id,name:_,display:_,create_time:_} = page;
        object::delete(id);
    }

}