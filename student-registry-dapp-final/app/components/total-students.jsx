export default function TotalStudents({ total = 4 }) {
  return (
    <div className="flex gap-x-3 items-center text-[#434446]">
      <h3 className="text-2xl leading-9 font-medium">Students</h3>
      <div className="w-[1px] h-3 rounded bg-[#D9D9D9]"></div>
      <h4 className="font-semibold  text-base leading-6 text-[#797979]">
        {total} Total
      </h4>
    </div>
  );
}
