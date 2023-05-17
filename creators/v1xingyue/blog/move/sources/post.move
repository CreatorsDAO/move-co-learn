module blog::post {

    use std::string::{String};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self,UID,ID};
    use sui::clock::{Self,Clock};

    struct AdminCap has key { id: UID,value:u64 }

    struct Post has key { 
        id: UID,
        title: String,
        content: String,
        order: u64,
        creator: address,
        create_time: u64,
        page_id:ID
    }

    fun init(ctx : &mut TxContext){
        transfer::transfer(AdminCap{
            id:object::new(ctx),
            value:2333
        },tx_context::sender(ctx));
    }

    public entry fun create_post(title: String, content: String,page_id:ID, now: &Clock,ctx: &mut TxContext) {
        transfer::transfer(Post{
            id:object::new(ctx),
            title,
            content,
            order:0,
            page_id,
            creator:tx_context::sender(ctx),
            create_time:clock::timestamp_ms(now)
        },tx_context::sender(ctx));
    }

    public entry fun update_post(title: String, content: String,page_id:ID, order: u64, post: &mut Post, _: &mut TxContext){
        post.title = title;
        post.content = content;
        post.order = order;
        post.page_id = page_id;
    }

    public entry fun delete_post(post:Post, _: &mut TxContext){
        let Post{id,title:_,content:_,order:_,create_time:_,creator:_,page_id:_} = post;
        object::delete(id);
    }

}
