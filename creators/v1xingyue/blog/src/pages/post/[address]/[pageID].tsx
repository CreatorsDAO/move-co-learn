import { useRouter } from 'next/router'
import { useEffect, useState } from 'react';
import { JsonRpcProvider, devnetConnection, mainnetConnection } from '@mysten/sui.js';
import {NETWORK,SUI_PACKAGE} from "../../../config/constants" ;


export default function AddressIndex (){
    const router = useRouter();
    const {address,pageID} = router.query;

    let connection = devnetConnection;
    if(NETWORK === "mainnet"){
        connection = mainnetConnection;
    }
    const provider = new JsonRpcProvider(connection);
    const [posts,setPosts] = useState<Array<{
        id:string,
        title:string,
        createTime:Number
    }>>([]);

    useEffect(()=>{
        (async()=>{
            if(address != null){
                const resp = await provider.getOwnedObjects({
                    owner: address as string,
                    filter:{
                        StructType:`${SUI_PACKAGE}::post::Post`
                    },
                    options:{
                        showType:true,
                        showContent:true,
                        showDisplay:true,
                    }
                });
                if (resp.data.length > 0) {
                    const posts = resp.data.filter((item:any)=>{
                        return item.data.content.fields.page_id === pageID;
                    }).map((item: any) => {
                      console.log(item);
                      const fields = item.data.content.fields as any;
                      return {
                        id: item.data.objectId,
                        title:fields.title,
                        createTime:fields.create_time
                      }
                    })
                    setPosts(posts)
                  }
            }
            
        })();
        console.log(`load ${address} page list ....`);
    }, [address]);

    // get my page list 
    // get other page list
   return (
    <>
        <h2 className="font-bold"> account:  {address}  </h2>
        <h2 className="font-bold"> page_id:  {pageID}  </h2>
        {
            posts.length > 0 ?
                posts.map((item: any) => { return  (
                    <div className="card mt-3 shadow-xl" key={item.id}>
                        <div className="card-body">
                            <h2 className="card-title">Post {item.title}</h2>
                            <p className="text-info"><a href={`/detail/${item.id}`}> Post Detail </a> </p>
                        </div>
                    </div>
                 ) })
                 :null
        }

    </>
   )
}