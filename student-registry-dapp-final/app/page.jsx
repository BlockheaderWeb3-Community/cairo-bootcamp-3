"use client";
import Balance from "./components/balance";
import Header from "./components/header";
import StudentsTable from "./components/students-table";
import StudentsTableControl from "./components/students-table-control";
import TotalStudents from "./components/total-students";
import { dummyStudents } from "./lib/data";
import { ABI } from "./abis/abi";
import { useContractRead } from "@starknet-react/core";
import Loading from "./components/loading";
export default function Home() {
  // TODO - Fetch Students from Contract
  const contractAddress =
    "0x03efd6a3549a0ea66468ba7f87d177bf2f18cb19ae7bba907f14f5897b9d9ed2";
  const {
    data: allStudents,
    refetch: allStudentsRefetch,
    isFetching,
    isLoading: readIsLoading,
  } = useContractRead({
    functionName: "get_all_students",
    args: [],
    abi: ABI,
    address: contractAddress,
    // watch: true,
  });

  console.log(allStudents);

  return (
    <div className="py-[60px] px-[100px]">
      <Header />
      {readIsLoading || isFetching ? (
        <Loading message={"Fetching students"} />
      ) : (
        <div className="mt-[60px]">
          <div className="flex justify-between items-center">
            {/* TODO - Pass correct students length */}
            <TotalStudents total={allStudents?.length} />
            <Balance />
          </div>
          {/* TODO - Pass correct students */}
          <StudentsTable
            students={allStudents.map((student, i) => {
              return { ...student, id: i + 1 };
            })}
          />
          {/* TODO - Pass correct students length */}
          <StudentsTableControl
            count={allStudents?.length}
            handleRefreshStudents={allStudentsRefetch}
          />
        </div>
      )}
    </div>
  );
}
