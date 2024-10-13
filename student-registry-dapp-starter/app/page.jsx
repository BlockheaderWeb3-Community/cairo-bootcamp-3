"use client";
import Balance from "./components/balance";
import Header from "./components/header";
import StudentsTable from "./components/students-table";
import StudentsTableControl from "./components/students-table-control";
import TotalStudents from "./components/total-students";
import { dummyStudents } from "./lib/data";

export default function Home() {
  // TODO - Fetch Students from Contract

  return (
    <div className="py-[60px] px-[100px]">
      <Header />
      <div className="mt-[60px]">
        <div className="flex justify-between items-center">
          {/* TODO: - Pass correct students length */}
          <TotalStudents total={dummyStudents?.length} />
          <Balance />
        </div>
        {/* TODO: - Pass correct students */}
        <StudentsTable students={dummyStudents} />
        {/* TODO: - Pass correct students length */}
        <StudentsTableControl
          count={dummyStudents?.length}
          handleRefreshStudents={() => console.log("Handle refetch")}
        />
      </div>
    </div>
  );
}
