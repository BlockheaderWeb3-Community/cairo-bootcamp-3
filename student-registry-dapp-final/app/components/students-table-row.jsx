"use client";

import { felt252ToString } from "../lib/helpers";

export default function StudentTableRow({ student }) {
  if (!student) return null;

  const { lname, fname, phone_number, age, is_active } = student;

  return (
    <div className="items-center grid grid-cols-[1fr_1fr_1fr_1fr_1fr] py-6 px-4 text-[#6F6F6F] font-normal capitalize">
      <div>{student.id}</div>
      <div>{felt252ToString(fname)}</div>
      <div>{felt252ToString(lname)}</div>
      <div>{`0${phone_number.toString()}`}</div>
      <div>{age.toString()}</div>
    </div>
  );
}
