import { SuiConnect } from "./SuiConnect";
import {
  MODULE_URL
} from "../config/constants";

export function NavBar() {
  return (
    <nav className="navbar py-4 px-4 bg-base-100">
      <div className="flex-1">
        <a href="/">
          <span className="font-bold underline">Suipress</span>
        </a>
        <ul className="menu menu-horizontal p-0 ml-5">
          <li className="font-sans font-semibold text-lg">
          <a href="/admin">Admin</a>
            <a href={MODULE_URL} target="_blank" rel="noreferrer">Contract on Explorer</a>
          </li>
        </ul>
      </div>
      <SuiConnect />
    </nav>
  );
}
