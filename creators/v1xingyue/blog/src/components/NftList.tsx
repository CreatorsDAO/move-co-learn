import { ObjectLink } from "../utils/links";
type NftListPros = { nfts: Array<{ url: string, id: string, name: string, description: string }> };
export function NftList({ nfts }: NftListPros) {
    return nfts && (
        <div className="card lg:card-side bg-base-100 shadow-xl mt-5">
            <div className="card-body">
                <h2 className="card-title">Minted NFTs:</h2>
                {
                    nfts.map((item, i) => <div className="gallery" key={item.id}>
                        <a target="_blank" rel="noreferrer" href={ObjectLink(item.id)}>
                            <img src={item.url} />
                            <div className="name">{item.name}</div>
                            <div className="desc">{item.description}</div>
                        </a>
                    </div>)
                }
            </div>
        </div >
    )
}