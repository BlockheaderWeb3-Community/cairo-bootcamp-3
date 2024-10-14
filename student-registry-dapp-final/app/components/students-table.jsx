"use client";
import { useSearchParams } from "next/navigation";
import StudentTableHeader from "./students-table-header";
import StudentTableRow from "./students-table-row";
import { PAGE_SIZE } from "../lib/data";

export default function StudentsTable({ students }) {
  const searchParams = useSearchParams();
  const page = searchParams.get("page") || "1";

  const from = (+page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE;

  if (!students?.length) return null;

  return (
    <div className="my-5 text-base leading-6">
      <StudentTableHeader />
      <div>
        {students?.slice(from, to).map((student, id) => (
          <StudentTableRow student={student} key={id} />
        ))}
      </div>
    </div>
  );
}
