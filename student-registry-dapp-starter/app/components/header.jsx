"use client";
import blockHeaderLogo from "../assets/block-header-logo.svg";
import starknetLogo from "../assets/starknet-logo.svg";
import Connector from "./connector";

export default function Header() {
  return (
    <div className="flex items-center justify-between">
      <div className="flex items-center gap-x-[22px]">
        <img src={blockHeaderLogo.src} alt="logo" />
        <span>X</span>
        <img src={starknetLogo.src} alt="logo" />
      </div>
      <Connector />
    </div>
  );
}
