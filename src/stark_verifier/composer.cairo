from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow

from stark_verifier.air.air_instance import AirInstance, DeepCompositionCoefficients
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.channel import Table
from stark_verifier.utils import Vec

struct DeepComposer {
    cc: DeepCompositionCoefficients,
    x_coordinates: felt*,
    z_curr: felt,
    z_next: felt,
}

func deep_composer_new{
    range_check_ptr
}(
    air: AirInstance,
    query_positions: felt*,
    z: felt,
    cc: DeepCompositionCoefficients,
) -> DeepComposer {
    alloc_locals;
    
    let g = air.trace_domain_generator;
    let g_lde = air.lde_domain_generator;
    let domain_offset = 3;

    // TODO: Don't hardcode the number of query positions here
    let (x_coordinates: felt*) = alloc();
    
    let (x) = pow(g_lde, query_positions[0]);
    let x = x * domain_offset;
    assert x_coordinates[0] = x;
    
    let (x) = pow(g_lde, query_positions[1]);
    let x = x * domain_offset;
    assert x_coordinates[1] = x;
    
    let (x) = pow(g_lde, query_positions[2]);
    let x = x * domain_offset;
    assert x_coordinates[2] = x;
    
    let (x) = pow(g_lde, query_positions[3]);
    let x = x * domain_offset;
    assert x_coordinates[3] = x;
    
    let (x) = pow(g_lde, query_positions[4]);
    let x = x * domain_offset;
    assert x_coordinates[4] = x;
    
    let (x) = pow(g_lde, query_positions[5]);
    let x = x * domain_offset;
    assert x_coordinates[5] = x;
    
    let (x) = pow(g_lde, query_positions[6]);
    let x = x * domain_offset;
    assert x_coordinates[6] = x;
    
    let (x) = pow(g_lde, query_positions[7]);
    let x = x * domain_offset;
    assert x_coordinates[7] = x;
    
    let (x) = pow(g_lde, query_positions[8]);
    let x = x * domain_offset;
    assert x_coordinates[8] = x;
    
    let (x) = pow(g_lde, query_positions[9]);
    let x = x * domain_offset;
    assert x_coordinates[9] = x;
    
    let (x) = pow(g_lde, query_positions[10]);
    let x = x * domain_offset;
    assert x_coordinates[10] = x;
    
    let (x) = pow(g_lde, query_positions[11]);
    let x = x * domain_offset;
    assert x_coordinates[11] = x;
    
    let (x) = pow(g_lde, query_positions[12]);
    let x = x * domain_offset;
    assert x_coordinates[12] = x;
    
    let (x) = pow(g_lde, query_positions[13]);
    let x = x * domain_offset;
    assert x_coordinates[13] = x;
    
    let (x) = pow(g_lde, query_positions[14]);
    let x = x * domain_offset;
    assert x_coordinates[14] = x;
    
    let (x) = pow(g_lde, query_positions[15]);
    let x = x * domain_offset;
    assert x_coordinates[15] = x;
    
    let (x) = pow(g_lde, query_positions[16]);
    let x = x * domain_offset;
    assert x_coordinates[16] = x;
    
    let (x) = pow(g_lde, query_positions[17]);
    let x = x * domain_offset;
    assert x_coordinates[17] = x;
    
    let (x) = pow(g_lde, query_positions[18]);
    let x = x * domain_offset;
    assert x_coordinates[18] = x;
    
    let (x) = pow(g_lde, query_positions[19]);
    let x = x * domain_offset;
    assert x_coordinates[19] = x;
    
    let (x) = pow(g_lde, query_positions[20]);
    let x = x * domain_offset;
    assert x_coordinates[20] = x;
    
    let (x) = pow(g_lde, query_positions[21]);
    let x = x * domain_offset;
    assert x_coordinates[21] = x;
    
    let (x) = pow(g_lde, query_positions[22]);
    let x = x * domain_offset;
    assert x_coordinates[22] = x;
    
    let (x) = pow(g_lde, query_positions[23]);
    let x = x * domain_offset;
    assert x_coordinates[23] = x;
    
    let (x) = pow(g_lde, query_positions[24]);
    let x = x * domain_offset;
    assert x_coordinates[24] = x;
    
    let (x) = pow(g_lde, query_positions[25]);
    let x = x * domain_offset;
    assert x_coordinates[25] = x;
    
    let (x) = pow(g_lde, query_positions[26]);
    let x = x * domain_offset;
    assert x_coordinates[26] = x;
    
    let (x) = pow(g_lde, query_positions[27]);
    let x = x * domain_offset;
    assert x_coordinates[27] = x;
    
    let (x) = pow(g_lde, query_positions[28]);
    let x = x * domain_offset;
    assert x_coordinates[28] = x;
    
    let (x) = pow(g_lde, query_positions[29]);
    let x = x * domain_offset;
    assert x_coordinates[29] = x;
    
    let (x) = pow(g_lde, query_positions[30]);
    let x = x * domain_offset;
    assert x_coordinates[30] = x;
    
    let (x) = pow(g_lde, query_positions[31]);
    let x = x * domain_offset;
    assert x_coordinates[31] = x;
    
    let (x) = pow(g_lde, query_positions[32]);
    let x = x * domain_offset;
    assert x_coordinates[32] = x;
    
    let (x) = pow(g_lde, query_positions[33]);
    let x = x * domain_offset;
    assert x_coordinates[33] = x;
    
    let (x) = pow(g_lde, query_positions[34]);
    let x = x * domain_offset;
    assert x_coordinates[34] = x;
    
    let (x) = pow(g_lde, query_positions[35]);
    let x = x * domain_offset;
    assert x_coordinates[35] = x;
    
    let (x) = pow(g_lde, query_positions[36]);
    let x = x * domain_offset;
    assert x_coordinates[36] = x;
    
    let (x) = pow(g_lde, query_positions[37]);
    let x = x * domain_offset;
    assert x_coordinates[37] = x;
    
    let (x) = pow(g_lde, query_positions[38]);
    let x = x * domain_offset;
    assert x_coordinates[38] = x;
    
    let (x) = pow(g_lde, query_positions[39]);
    let x = x * domain_offset;
    assert x_coordinates[39] = x;
    
    let (x) = pow(g_lde, query_positions[40]);
    let x = x * domain_offset;
    assert x_coordinates[40] = x;
    
    let (x) = pow(g_lde, query_positions[41]);
    let x = x * domain_offset;
    assert x_coordinates[41] = x;
    
    let (x) = pow(g_lde, query_positions[42]);
    let x = x * domain_offset;
    assert x_coordinates[42] = x;
    
    let (x) = pow(g_lde, query_positions[43]);
    let x = x * domain_offset;
    assert x_coordinates[43] = x;
    
    let (x) = pow(g_lde, query_positions[44]);
    let x = x * domain_offset;
    assert x_coordinates[44] = x;
    
    let (x) = pow(g_lde, query_positions[45]);
    let x = x * domain_offset;
    assert x_coordinates[45] = x;
    
    let (x) = pow(g_lde, query_positions[46]);
    let x = x * domain_offset;
    assert x_coordinates[46] = x;
    
    let (x) = pow(g_lde, query_positions[47]);
    let x = x * domain_offset;
    assert x_coordinates[47] = x;
    
    let (x) = pow(g_lde, query_positions[48]);
    let x = x * domain_offset;
    assert x_coordinates[48] = x;
    
    let (x) = pow(g_lde, query_positions[49]);
    let x = x * domain_offset;
    assert x_coordinates[49] = x;
    
    let (x) = pow(g_lde, query_positions[50]);
    let x = x * domain_offset;
    assert x_coordinates[50] = x;
    
    let (x) = pow(g_lde, query_positions[51]);
    let x = x * domain_offset;
    assert x_coordinates[51] = x;
    
    let (x) = pow(g_lde, query_positions[52]);
    let x = x * domain_offset;
    assert x_coordinates[52] = x;
    
    let (x) = pow(g_lde, query_positions[53]);
    let x = x * domain_offset;
    assert x_coordinates[53] = x;
    

    let z_curr = z;
    let z_next = z * g;

    let res = DeepComposer(
        cc,
        x_coordinates,
        z_curr,
        z_next,
    );
    return res;
}

func compose_trace_columns(
    composer: DeepComposer,
    queried_main_trace_states: Table,
    queried_aux_trace_states: Table,
    ood_main_frame: EvaluationFrame,
    ood_aux_frame: EvaluationFrame,
) -> felt* {

    let (result: felt*) = alloc();

    // Main trace coefficient rows
    let n_cols = queried_main_trace_states.n_cols;
    let cc_trace_curr = composer.cc.trace.values;
    let cc_trace_next = composer.cc.trace.values + n_cols;

    let z_curr = composer.z_curr;
    let z_next = composer.z_next;

    // Compose columns of the main segment
    // TODO: Don't hardcode the number of query and columns
    tempvar n = 54;
    let curr = queried_main_trace_states.elements;
    let next = (queried_main_trace_states.elements + n_cols);
    tempvar curr_ptr = curr;
    tempvar next_ptr = next;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result;
    loop_main:
        tempvar sum_curr = 0;
        tempvar sum_next = 0;
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[0]) * cc_trace_curr[0];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[0]) * cc_trace_next[0];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[1]) * cc_trace_curr[1];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[1]) * cc_trace_next[1];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[2]) * cc_trace_curr[2];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[2]) * cc_trace_next[2];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[3]) * cc_trace_curr[3];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[3]) * cc_trace_next[3];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[4]) * cc_trace_curr[4];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[4]) * cc_trace_next[4];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[5]) * cc_trace_curr[5];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[5]) * cc_trace_next[5];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[6]) * cc_trace_curr[6];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[6]) * cc_trace_next[6];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[7]) * cc_trace_curr[7];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[7]) * cc_trace_next[7];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[8]) * cc_trace_curr[8];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[8]) * cc_trace_next[8];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[9]) * cc_trace_curr[9];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[9]) * cc_trace_next[9];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[10]) * cc_trace_curr[10];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[10]) * cc_trace_next[10];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[11]) * cc_trace_curr[11];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[11]) * cc_trace_next[11];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[12]) * cc_trace_curr[12];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[12]) * cc_trace_next[12];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[13]) * cc_trace_curr[13];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[13]) * cc_trace_next[13];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[14]) * cc_trace_curr[14];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[14]) * cc_trace_next[14];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[15]) * cc_trace_curr[15];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[15]) * cc_trace_next[15];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[16]) * cc_trace_curr[16];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[16]) * cc_trace_next[16];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[17]) * cc_trace_curr[17];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[17]) * cc_trace_next[17];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[18]) * cc_trace_curr[18];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[18]) * cc_trace_next[18];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[19]) * cc_trace_curr[19];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[19]) * cc_trace_next[19];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[20]) * cc_trace_curr[20];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[20]) * cc_trace_next[20];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[21]) * cc_trace_curr[21];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[21]) * cc_trace_next[21];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[22]) * cc_trace_curr[22];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[22]) * cc_trace_next[22];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[23]) * cc_trace_curr[23];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[23]) * cc_trace_next[23];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[24]) * cc_trace_curr[24];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[24]) * cc_trace_next[24];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[25]) * cc_trace_curr[25];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[25]) * cc_trace_next[25];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[26]) * cc_trace_curr[26];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[26]) * cc_trace_next[26];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[27]) * cc_trace_curr[27];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[27]) * cc_trace_next[27];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[28]) * cc_trace_curr[28];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[28]) * cc_trace_next[28];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[29]) * cc_trace_curr[29];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[29]) * cc_trace_next[29];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[30]) * cc_trace_curr[30];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[30]) * cc_trace_next[30];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[31]) * cc_trace_curr[31];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[31]) * cc_trace_next[31];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_main_frame.current[32]) * cc_trace_curr[32];
        tempvar sum_next = sum_next + ([next_ptr] - ood_main_frame.next[32]) * cc_trace_next[32];
        
        tempvar x = [x_coord_ptr];
        tempvar sum = sum_curr / (x - z_curr) + sum_next / (x - z_next);
        assert [result_ptr] = sum;

        tempvar n = n - 1;
        tempvar curr_ptr = curr_ptr + 1;
        tempvar next_ptr = next_ptr + 1;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop_main if n != 0;
    
    // Aux trace coefficient rows
    let n_cols = queried_aux_trace_states.n_cols;
    let cc_trace_curr = cc_trace_next;
    let cc_trace_next = cc_trace_next + n_cols;

    // Compose columns of the aux segments
    let curr = queried_aux_trace_states.elements;
    let next = (queried_aux_trace_states.elements + n_cols);
    tempvar curr_ptr = curr;
    tempvar next_ptr = next;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result;
    loop_aux:
        tempvar sum_curr = 0;
        tempvar sum_next = 0;
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[33]) * cc_trace_curr[33];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[33]) * cc_trace_next[33];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[34]) * cc_trace_curr[34];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[34]) * cc_trace_next[34];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[35]) * cc_trace_curr[35];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[35]) * cc_trace_next[35];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[36]) * cc_trace_curr[36];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[36]) * cc_trace_next[36];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[37]) * cc_trace_curr[37];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[37]) * cc_trace_next[37];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[38]) * cc_trace_curr[38];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[38]) * cc_trace_next[38];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[39]) * cc_trace_curr[39];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[39]) * cc_trace_next[39];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[40]) * cc_trace_curr[40];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[40]) * cc_trace_next[40];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[41]) * cc_trace_curr[41];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[41]) * cc_trace_next[41];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[42]) * cc_trace_curr[42];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[42]) * cc_trace_next[42];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[43]) * cc_trace_curr[43];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[43]) * cc_trace_next[43];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[44]) * cc_trace_curr[44];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[44]) * cc_trace_next[44];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[45]) * cc_trace_curr[45];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[45]) * cc_trace_next[45];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[46]) * cc_trace_curr[46];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[46]) * cc_trace_next[46];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[47]) * cc_trace_curr[47];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[47]) * cc_trace_next[47];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[48]) * cc_trace_curr[48];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[48]) * cc_trace_next[48];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[49]) * cc_trace_curr[49];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[49]) * cc_trace_next[49];
        
        tempvar sum_curr = sum_curr + ([curr_ptr] - ood_aux_frame.current[50]) * cc_trace_curr[50];
        tempvar sum_next = sum_next + ([next_ptr] - ood_aux_frame.next[50]) * cc_trace_next[50];
        
        tempvar x = [x_coord_ptr];
        tempvar sum = sum_curr / (x - z_curr) + sum_next / (x - z_next);
        assert [result_ptr] = sum;

        tempvar n = n - 1;
        tempvar curr_ptr = curr_ptr + 1;
        tempvar next_ptr = next_ptr + 1;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop_aux if n != 0;

    let (data: felt*) = alloc();
    return data;
}

func compose_constraint_evaluations(
    composer: DeepComposer, queried_evaluations: Table, ood_evaluations: Vec
) -> felt* {
    // TODO
    let (data: felt*) = alloc();
    return data;
}

func combine_compositions(
    composer: DeepComposer, t_composition: felt*, c_composition: felt*
) -> felt* {
    // TODO
    let (data: felt*) = alloc();
    return data;
}
