from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.pow import pow

from stark_verifier.air.air_instance import AirInstance, DeepCompositionCoefficients
from stark_verifier.air.transitions.frame import EvaluationFrame
from stark_verifier.channel import Table
from stark_verifier.utils import Vec

struct DeepComposer {
    x_coordinates: felt*,
    z_curr: felt,
    z_next: felt,
    cc: DeepCompositionCoefficients,
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

func compose_trace_columns{
    range_check_ptr
}(
    composer: DeepComposer,
    queried_main_trace_states: Table,
    queried_aux_trace_states: Table,
    ood_main_frame: EvaluationFrame,
    ood_aux_frame: EvaluationFrame,
) -> felt* {
    alloc_locals;

    // Main trace coefficient rows
    let n_cols = queried_main_trace_states.n_cols;

    let z_curr = composer.z_curr;
    let z_next = composer.z_next;

    // Compose columns of the main segment
    let row = queried_main_trace_states.elements;
    let (local result: felt*) = alloc();
    // TODO: Don't hardcode the number of query and columns
    tempvar n = 54;
    tempvar row_ptr = row;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result;
    loop_main:
        tempvar sum_curr = 0;
        tempvar sum_next = 0;
        
        tempvar sum_curr = sum_curr + ([row_ptr + 0] - ood_main_frame.current[0]) * composer.cc.trace[0].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 0] - ood_main_frame.next[0]) * composer.cc.trace[0].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 1] - ood_main_frame.current[1]) * composer.cc.trace[1].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 1] - ood_main_frame.next[1]) * composer.cc.trace[1].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 2] - ood_main_frame.current[2]) * composer.cc.trace[2].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 2] - ood_main_frame.next[2]) * composer.cc.trace[2].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 3] - ood_main_frame.current[3]) * composer.cc.trace[3].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 3] - ood_main_frame.next[3]) * composer.cc.trace[3].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 4] - ood_main_frame.current[4]) * composer.cc.trace[4].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 4] - ood_main_frame.next[4]) * composer.cc.trace[4].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 5] - ood_main_frame.current[5]) * composer.cc.trace[5].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 5] - ood_main_frame.next[5]) * composer.cc.trace[5].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 6] - ood_main_frame.current[6]) * composer.cc.trace[6].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 6] - ood_main_frame.next[6]) * composer.cc.trace[6].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 7] - ood_main_frame.current[7]) * composer.cc.trace[7].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 7] - ood_main_frame.next[7]) * composer.cc.trace[7].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 8] - ood_main_frame.current[8]) * composer.cc.trace[8].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 8] - ood_main_frame.next[8]) * composer.cc.trace[8].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 9] - ood_main_frame.current[9]) * composer.cc.trace[9].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 9] - ood_main_frame.next[9]) * composer.cc.trace[9].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 10] - ood_main_frame.current[10]) * composer.cc.trace[10].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 10] - ood_main_frame.next[10]) * composer.cc.trace[10].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 11] - ood_main_frame.current[11]) * composer.cc.trace[11].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 11] - ood_main_frame.next[11]) * composer.cc.trace[11].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 12] - ood_main_frame.current[12]) * composer.cc.trace[12].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 12] - ood_main_frame.next[12]) * composer.cc.trace[12].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 13] - ood_main_frame.current[13]) * composer.cc.trace[13].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 13] - ood_main_frame.next[13]) * composer.cc.trace[13].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 14] - ood_main_frame.current[14]) * composer.cc.trace[14].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 14] - ood_main_frame.next[14]) * composer.cc.trace[14].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 15] - ood_main_frame.current[15]) * composer.cc.trace[15].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 15] - ood_main_frame.next[15]) * composer.cc.trace[15].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 16] - ood_main_frame.current[16]) * composer.cc.trace[16].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 16] - ood_main_frame.next[16]) * composer.cc.trace[16].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 17] - ood_main_frame.current[17]) * composer.cc.trace[17].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 17] - ood_main_frame.next[17]) * composer.cc.trace[17].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 18] - ood_main_frame.current[18]) * composer.cc.trace[18].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 18] - ood_main_frame.next[18]) * composer.cc.trace[18].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 19] - ood_main_frame.current[19]) * composer.cc.trace[19].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 19] - ood_main_frame.next[19]) * composer.cc.trace[19].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 20] - ood_main_frame.current[20]) * composer.cc.trace[20].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 20] - ood_main_frame.next[20]) * composer.cc.trace[20].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 21] - ood_main_frame.current[21]) * composer.cc.trace[21].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 21] - ood_main_frame.next[21]) * composer.cc.trace[21].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 22] - ood_main_frame.current[22]) * composer.cc.trace[22].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 22] - ood_main_frame.next[22]) * composer.cc.trace[22].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 23] - ood_main_frame.current[23]) * composer.cc.trace[23].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 23] - ood_main_frame.next[23]) * composer.cc.trace[23].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 24] - ood_main_frame.current[24]) * composer.cc.trace[24].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 24] - ood_main_frame.next[24]) * composer.cc.trace[24].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 25] - ood_main_frame.current[25]) * composer.cc.trace[25].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 25] - ood_main_frame.next[25]) * composer.cc.trace[25].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 26] - ood_main_frame.current[26]) * composer.cc.trace[26].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 26] - ood_main_frame.next[26]) * composer.cc.trace[26].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 27] - ood_main_frame.current[27]) * composer.cc.trace[27].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 27] - ood_main_frame.next[27]) * composer.cc.trace[27].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 28] - ood_main_frame.current[28]) * composer.cc.trace[28].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 28] - ood_main_frame.next[28]) * composer.cc.trace[28].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 29] - ood_main_frame.current[29]) * composer.cc.trace[29].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 29] - ood_main_frame.next[29]) * composer.cc.trace[29].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 30] - ood_main_frame.current[30]) * composer.cc.trace[30].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 30] - ood_main_frame.next[30]) * composer.cc.trace[30].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 31] - ood_main_frame.current[31]) * composer.cc.trace[31].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 31] - ood_main_frame.next[31]) * composer.cc.trace[31].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 32] - ood_main_frame.current[32]) * composer.cc.trace[32].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 32] - ood_main_frame.next[32]) * composer.cc.trace[32].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 33] - ood_main_frame.current[33]) * composer.cc.trace[33].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 33] - ood_main_frame.next[33]) * composer.cc.trace[33].values[1];
        
        tempvar x = [x_coord_ptr];
        tempvar sum = sum_curr / (x - z_curr) + sum_next / (x - z_next);
        assert [result_ptr] = sum;

        tempvar n = n - 1;
        tempvar row_ptr = row_ptr + n_cols;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop_main if n != 0;
    
    // Aux trace coefficient rows
    let n_cols = queried_aux_trace_states.n_cols;

    // Compose columns of the aux segments
    let row = queried_aux_trace_states.elements;
    tempvar n = 54; // TODO: double-check this value!
    tempvar row_ptr = row;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result_ptr;
    loop_aux:
        tempvar sum_curr = 0;
        tempvar sum_next = 0;
        
        tempvar sum_curr = sum_curr + ([row_ptr + 0] - ood_aux_frame.current[0]) * composer.cc.trace[34].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 0] - ood_aux_frame.next[0]) * composer.cc.trace[34].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 1] - ood_aux_frame.current[1]) * composer.cc.trace[35].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 1] - ood_aux_frame.next[1]) * composer.cc.trace[35].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 2] - ood_aux_frame.current[2]) * composer.cc.trace[36].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 2] - ood_aux_frame.next[2]) * composer.cc.trace[36].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 3] - ood_aux_frame.current[3]) * composer.cc.trace[37].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 3] - ood_aux_frame.next[3]) * composer.cc.trace[37].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 4] - ood_aux_frame.current[4]) * composer.cc.trace[38].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 4] - ood_aux_frame.next[4]) * composer.cc.trace[38].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 5] - ood_aux_frame.current[5]) * composer.cc.trace[39].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 5] - ood_aux_frame.next[5]) * composer.cc.trace[39].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 6] - ood_aux_frame.current[6]) * composer.cc.trace[40].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 6] - ood_aux_frame.next[6]) * composer.cc.trace[40].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 7] - ood_aux_frame.current[7]) * composer.cc.trace[41].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 7] - ood_aux_frame.next[7]) * composer.cc.trace[41].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 8] - ood_aux_frame.current[8]) * composer.cc.trace[42].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 8] - ood_aux_frame.next[8]) * composer.cc.trace[42].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 9] - ood_aux_frame.current[9]) * composer.cc.trace[43].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 9] - ood_aux_frame.next[9]) * composer.cc.trace[43].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 10] - ood_aux_frame.current[10]) * composer.cc.trace[44].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 10] - ood_aux_frame.next[10]) * composer.cc.trace[44].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 11] - ood_aux_frame.current[11]) * composer.cc.trace[45].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 11] - ood_aux_frame.next[11]) * composer.cc.trace[45].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 12] - ood_aux_frame.current[12]) * composer.cc.trace[46].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 12] - ood_aux_frame.next[12]) * composer.cc.trace[46].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 13] - ood_aux_frame.current[13]) * composer.cc.trace[47].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 13] - ood_aux_frame.next[13]) * composer.cc.trace[47].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 14] - ood_aux_frame.current[14]) * composer.cc.trace[48].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 14] - ood_aux_frame.next[14]) * composer.cc.trace[48].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 15] - ood_aux_frame.current[15]) * composer.cc.trace[49].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 15] - ood_aux_frame.next[15]) * composer.cc.trace[49].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 16] - ood_aux_frame.current[16]) * composer.cc.trace[50].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 16] - ood_aux_frame.next[16]) * composer.cc.trace[50].values[1];
        
        tempvar sum_curr = sum_curr + ([row_ptr + 17] - ood_aux_frame.current[17]) * composer.cc.trace[51].values[0];
        tempvar sum_next = sum_next + ([row_ptr + 17] - ood_aux_frame.next[17]) * composer.cc.trace[51].values[1];
        
        tempvar x = [x_coord_ptr];
        tempvar sum = sum_curr / (x - z_curr) + sum_next / (x - z_next);
        assert [result_ptr] = sum;

        tempvar n = n - 1;
        tempvar row_ptr = row_ptr + n_cols;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop_aux if n != 0;

    return result;
}

func compose_constraint_evaluations{
    range_check_ptr
}(
    composer: DeepComposer,
    queried_evaluations: Table,
    ood_evaluations: Vec,
) -> felt* {
    alloc_locals;

    // Compute z^m
    let num_eval_columns = ood_evaluations.n_elements;
    let z = composer.z_curr;
    let (local z_m) = pow(z, num_eval_columns);
    local range_check_ptr = range_check_ptr;

    local n_cols = queried_evaluations.n_cols;
    local cc_constraint: felt* = composer.cc.constraints;

    local row: felt* = queried_evaluations.elements;
    let (local result: felt*) = alloc();
    // TODO: Don't hardcode number of queries
    tempvar n = 54;
    tempvar row_ptr = row;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result;
    loop:
        tempvar sum = 0;
        
        tempvar sum = sum + (row_ptr[0] - ood_evaluations.elements[0]) * cc_constraint[0]; 
        tempvar sum = sum + (row_ptr[1] - ood_evaluations.elements[1]) * cc_constraint[1]; 
        tempvar sum = sum + (row_ptr[2] - ood_evaluations.elements[2]) * cc_constraint[2]; 
        tempvar sum = sum + (row_ptr[3] - ood_evaluations.elements[3]) * cc_constraint[3]; 
        tempvar x = [x_coord_ptr];
        tempvar sum = sum / (x - z_m);
        assert [result_ptr] = sum;

        tempvar n = n - 1;
        tempvar row_ptr = row_ptr + n_cols;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop if n != 0;

    return result;
}

func combine_compositions(
    composer: DeepComposer,
    t_composition: felt*,
    c_composition: felt*
) -> felt* {
    alloc_locals;

    let cc_degree_0 = composer.cc.degree_lambda;
    let cc_degree_1 = composer.cc.degree_mu;
    
    let (local result: felt*) = alloc();
    // TODO: Don't hardcode number of queries
    tempvar n = 54;
    tempvar t_ptr = t_composition;
    tempvar c_ptr = c_composition;
    tempvar x_coord_ptr = composer.x_coordinates;
    tempvar result_ptr = result;
    loop:
        tempvar x = [x_coord_ptr];
        tempvar t = [t_ptr];
        tempvar c = [c_ptr];
        tempvar composition = t + c;
        tempvar composition = composition * (cc_degree_0 + x * cc_degree_1);
        assert [result_ptr] = composition;

        tempvar n = n - 1;
        tempvar t_ptr = t_ptr + 1;
        tempvar c_ptr = c_ptr + 1;
        tempvar x_coord_ptr = x_coord_ptr + 1;
        tempvar result_ptr = result_ptr + 1;
    jmp loop if n != 0;

    return result;
}
