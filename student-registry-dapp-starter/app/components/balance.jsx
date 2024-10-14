export default function Balance() {
  // TODO: - Fetch connected user's balance

  return (
    <div className="flex gap-x-3 items-center text-[#6F6F6F] text-base leading-6">
      <h3 className="">Wallet balance</h3>
      <div className="w-[1px] h-3 rounded bg-[#D9D9D9]"></div>
      <h4 className="font-semibold">$565.15</h4>
    </div>
  );
}
