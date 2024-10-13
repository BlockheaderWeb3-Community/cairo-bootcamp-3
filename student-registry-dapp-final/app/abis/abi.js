export const ABI = [
  {
    type: "impl",
    name: "StudentRegistryImpl",
    interface_name: "cairo_bootcamp_3::student_registry::IStudentRegistry",
  },
  {
    type: "enum",
    name: "core::bool",
    variants: [
      {
        name: "False",
        type: "()",
      },
      {
        name: "True",
        type: "()",
      },
    ],
  },
  {
    type: "struct",
    name: "cairo_bootcamp_3::student_struct::Student",
    members: [
      {
        name: "fname",
        type: "core::felt252",
      },
      {
        name: "lname",
        type: "core::felt252",
      },
      {
        name: "phone_number",
        type: "core::felt252",
      },
      {
        name: "age",
        type: "core::integer::u8",
      },
      {
        name: "is_active",
        type: "core::bool",
      },
    ],
  },
  {
    type: "struct",
    name: "core::array::Span::<cairo_bootcamp_3::student_struct::Student>",
    members: [
      {
        name: "snapshot",
        type: "@core::array::Array::<cairo_bootcamp_3::student_struct::Student>",
      },
    ],
  },
  {
    type: "interface",
    name: "cairo_bootcamp_3::student_registry::IStudentRegistry",
    items: [
      {
        type: "function",
        name: "add_student",
        inputs: [
          {
            name: "_fname",
            type: "core::felt252",
          },
          {
            name: "_lname",
            type: "core::felt252",
          },
          {
            name: "_phone_number",
            type: "core::felt252",
          },
          {
            name: "_age",
            type: "core::integer::u8",
          },
          {
            name: "_is_active",
            type: "core::bool",
          },
        ],
        outputs: [
          {
            type: "core::bool",
          },
        ],
        state_mutability: "external",
      },
      {
        type: "function",
        name: "get_student",
        inputs: [
          {
            name: "index",
            type: "core::integer::u64",
          },
        ],
        outputs: [
          {
            type: "(core::felt252, core::felt252, core::felt252, core::integer::u8, core::bool)",
          },
        ],
        state_mutability: "view",
      },
      {
        type: "function",
        name: "get_all_students",
        inputs: [],
        outputs: [
          {
            type: "core::array::Span::<cairo_bootcamp_3::student_struct::Student>",
          },
        ],
        state_mutability: "view",
      },
      {
        type: "function",
        name: "update_student",
        inputs: [
          {
            name: "_index",
            type: "core::integer::u64",
          },
          {
            name: "_fname",
            type: "core::felt252",
          },
          {
            name: "_lname",
            type: "core::felt252",
          },
          {
            name: "_phone_number",
            type: "core::felt252",
          },
          {
            name: "_age",
            type: "core::integer::u8",
          },
        ],
        outputs: [
          {
            type: "core::bool",
          },
        ],
        state_mutability: "external",
      },
      {
        type: "function",
        name: "delete_student",
        inputs: [
          {
            name: "_index",
            type: "core::integer::u64",
          },
        ],
        outputs: [
          {
            type: "core::bool",
          },
        ],
        state_mutability: "external",
      },
    ],
  },
  {
    type: "constructor",
    name: "constructor",
    inputs: [
      {
        name: "_admin",
        type: "core::starknet::contract_address::ContractAddress",
      },
    ],
  },
  {
    type: "event",
    name: "cairo_bootcamp_3::student_registry::StudentRegistry::Event",
    kind: "enum",
    variants: [],
  },
];
