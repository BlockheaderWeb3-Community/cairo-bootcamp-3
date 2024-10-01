// GRADE SCORE FLOW
// Add GRADE for student
// view a student
// update student grade
// delete student grade


 use core::dict::Felt252Dict;

#[derive(Drop, Debug)]
fn main() {



let mut scores: Felt252Dict<u64> = Default::default();

    // add student scors
    scores.insert('mubitech', 5);   
    scores.insert('Smart', 56);
    scores.insert('victor', 20);
    scores.insert('paul', 30);

    // view all scores
    // println!("All Scores {}", scores);
    // let index = 0;
    // while index < 4 {

    // }
    // Get specific score for student
    let score = scores.get('mubitech');
    println!("mubitech score: {}", score);

    // UPDATE STUDENT GRADE
    scores.insert('zeal', 45);

    let mubitech_score = scores.get('mubitech');
    println!("mubitech score: {}", mubitech_score);


    // DELETE STUDENT SCORES
    scores.insert('zeal', 0);

    let zeal_score = scores.get('zeal');
    println!("zeal score: {}", zeal_score);

}