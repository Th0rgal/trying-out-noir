use dep::std;

global VOTER_COUNT = 2;
global CANDIDATE_COUNT = 10;

fn main(all_votes : [u32; VOTER_COUNT*CANDIDATE_COUNT], commitments : [Field; VOTER_COUNT], secrets: [Field; VOTER_COUNT]) -> pub [u32; CANDIDATE_COUNT] {
    check_commitments(commitments, secrets, all_votes);
    sum_votes(all_votes)
}

fn sum_votes(all_votes : [u32; VOTER_COUNT*CANDIDATE_COUNT]) -> pub [u32; CANDIDATE_COUNT] {
    let mut output = [0; CANDIDATE_COUNT] ;
    for i in 0..VOTER_COUNT{
        for j in 0..CANDIDATE_COUNT{   
            output[j] =  output[j]  + all_votes[j + i * CANDIDATE_COUNT];
        }
    }
    output
}

fn check_commitments(commitments : [Field; VOTER_COUNT], secrets: [Field; VOTER_COUNT], all_votes : [u32; VOTER_COUNT*CANDIDATE_COUNT]) {
    for i in 0..VOTER_COUNT {
        let mut transcript = [0; CANDIDATE_COUNT + 1];
        transcript[0] = secrets[i];
        for j in 0..CANDIDATE_COUNT {
            transcript[i + 1] = all_votes[j + i*CANDIDATE_COUNT] as Field;
        };
        constrain commitments[i] == std::hash::pedersen(transcript)[0];
    };
}