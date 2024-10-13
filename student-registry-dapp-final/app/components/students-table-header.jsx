import React from "react";

export default function StudentTableHeader() {
  return (
    <div className="items-center grid grid-cols-[1fr_1fr_1fr_1fr_1fr] py-6 px-4 border-b-[#c4c4c4] border-b-[1px] text-[#434446] font-medium">
      <div>ID number</div>
      <div>Surname</div>
      <div>First name</div>
      <div>Phone number</div>
      <div>Age</div>
    </div>
  );
}
