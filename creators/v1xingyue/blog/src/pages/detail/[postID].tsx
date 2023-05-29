import { useRouter } from 'next/router'
import { useEffect, useState } from 'react';
import { JsonRpcProvider, devnetConnection, mainnetConnection } from '@mysten/sui.js';
import {NETWORK} from "../../config/constants" ;

export default function AddressIndex (){
    const router = useRouter();
    const {postID} = router.query;

    let connection = devnetConnection;
    if(NETWORK === "mainnet"){
        connection = mainnetConnection;
    }
    const provider = new JsonRpcProvider(connection);
    const [post,setPost] = useState<any>({});
    const [loaded,updateLoad] = useState(false);

    useEffect(()=>{
        (async()=>{
            if(postID != null){
                const resp = await provider.getObject({
                    id: postID as string,
                    options:{
                        showType:true,
                        showContent:true,
                        showDisplay:true,
                    }
                });
                
                if (resp.error == null) {
                    setPost(resp.data);
                    console.log(resp.data);
                }
                updateLoad(true);
            }
            
        })();
    }, [postID]);

    // get my page list 
    // get other page list
   return (
    <>
        {loaded ? (
            <>
                <p>{post.content.fields.title}</p>
                <p>{post.objectId}</p>
                <p>{post.content.type}</p>
                <p>{post.content.fields.content}</p>
                <p>{post.content.fields.create_time}</p>
            </>
        ): "loading...." }
    </>
   )
}