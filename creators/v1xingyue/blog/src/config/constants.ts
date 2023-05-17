export const SUI_PACKAGE = process.env.NEXT_PUBLIC_DAPP_PACKAGE!; // changed here.
export const NETWORK = process.env.NEXT_PUBLIC_SUI_NETWORK!;
export const MODULE_URL = `https://explorer.sui.io/object/${SUI_PACKAGE}?network=${NETWORK}` 