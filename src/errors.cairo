pub mod Errors {
    pub const NOT_OWNER: felt252 = 'CALLER NOT OWNER';
    pub const NOT_ADMIN: felt252 = 'CALLER NOT ADMIN';
    pub const ZERO_ADDRESS: felt252 = 'ZERO ADDRESS!';
    pub const SAME_ADDRESS: felt252 = 'CANNOT BE SAME ADDRESS!';
    pub const ZERO_VALUE: felt252 = 'CANNOT BE ZERO_VALUE!';
    pub const STUDENT_NOT_REGISTERED: felt252 = 'STUDENT NOT REGISTERED!';
    pub const AGE_ZERO: felt252 = 'AGE CANNOT BE ZERO!';
    pub const ADMIN_CANNOT_BE_STUDENT: felt252 = 'ADMIN CANNOT BE STUDENT';
    pub const STUDENT_ALREADY_REGISTERED: felt252 = 'STUDENT ALREADY REGISTERED';

}
