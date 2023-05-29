
import { NETWORK } from "../config/constants";

const ExplorerBase = "https://explorer.sui.io";

export function TransacitonLink(digest: string, module: string) {
    return `${ExplorerBase}/txblock/${digest}?module=${module}&network=${NETWORK}`
}

export function ObjectLink(objectId: string) {
    return `${ExplorerBase}/object/${objectId}?network=${NETWORK}`;
}

export function PackageLink(packageId: string) {
    return `${ExplorerBase}/object/${packageId}?network=${NETWORK}`;
}