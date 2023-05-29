import { useRouter } from 'next/router'
import { useEffect, useState } from 'react';
import { JsonRpcProvider, devnetConnection, mainnetConnection } from '@mysten/sui.js';
import {NETWORK,SUI_PACKAGE} from "../../config/constants" ;


export default function AddressIndex (){
    const router = useRouter();
    const {address} = router.query;

    let connection = devnetConnection;
    if(NETWORK === "mainnet"){
        connection = mainnetConnection;
    }
    const provider = new JsonRpcProvider(connection);
    const [pages,setPages] = useState<Array<{
        id:string,
        name:string,
        display:string,
        createTime:Number
    }>>([]);

    useEffect(()=>{
        (async()=>{
            if(address != null){
                const resp = await provider.getOwnedObjects({
                    owner: address as string,
                    filter:{
                        StructType:`${SUI_PACKAGE}::page::Page`
                    },
                    options:{
                        showType:true,
                        showContent:true,
                        showDisplay:true,
                    }
                });
                if (resp.data.length > 0) {
                    const pages = resp.data.map((item: any) => {
                      console.log(item);
                      const fields = item.data.content.fields as any;
                      return {
                        id: item.data.objectId,
                        name:fields.name,
                        display:fields.display,
                        createTime:fields.create_time
                      }
                    })
                    setPages(pages)
                  }
            }
            
        })();
        console.log(`load ${address} page list ....`);
    }, [address]);

    // get my page list 
    // get other page list
   return (
    <>
        <h2 className="font-bold"> {address} --- blog on sui !!!  </h2>
        {
            pages.length > 0 ?
                 pages.map((item: any) => { return  (
                    <div className="card mt-3 shadow-xl" key={item.id}>
                        <div className="card-body">
                            <h2 className="card-title">Page {item.name}</h2>
                            <p>{item.display} </p>
                            <p className="text-info"><a href={`/post/${address}/${item.id}`}> Post List </a> </p>
                        </div>
                    </div>
                 ) })
                 :null
        }

    </>
   )
}