import { useWallet } from "@suiet/wallet-kit";

export default function Home(){
    const {address} = useWallet();
    return (
        <>
            <a className="link link-info" href={`/user/${address}`}> Go to my page list !! </a>
        </>
    );
}