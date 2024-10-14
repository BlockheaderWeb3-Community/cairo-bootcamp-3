"use client";
export default function StudentTableRow({ student }) {
  if (!student) return null;

  return (
    <div className="items-center grid grid-cols-[1fr_1fr_1fr_1fr_1fr] py-6 px-4 text-[#6F6F6F] font-normal capitalize">
      <div>{student.id}</div>
      <div>{student.surname}</div>
      <div>{student.first_name}</div>
      <div>{student.phone_number}</div>
      <div>{student.age}</div>
    </div>
  );
}
