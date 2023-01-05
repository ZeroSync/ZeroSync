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

    let n_cols = queried_main_trace_states.n_cols;
    let curr = queried_main_trace_states.elements;
    let next = (queried_main_trace_states.elements + n_cols);

    // Trace coefficient rows
    let cc_trace_curr = composer.cc.trace.values;
    let cc_trace_next = composer.cc.trace.values + n_cols;

    let z_curr = composer.z_curr;
    let z_next = composer.z_next;

    // Compose columns of the main segment
    // TODO: Don't hardcode the number of query and columns
    let (result: felt*) = alloc();
    
    let x = composer.x_coordinates[0];
    let sum = 0;
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[0] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[0] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[0] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[0] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[0] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[0] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[0] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[0] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[0] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[0] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[0] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[0] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[0] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[0] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[0] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[0] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[0] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[0] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[0] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[0] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[0] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[0] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[0] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[0] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[0] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[0] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[0] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[0] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[0] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[0] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[0] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[0] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[0] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[0] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[0] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[0] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[0] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[0] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[0] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[0] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[0] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[0] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[0] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[0] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[0] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[0] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[0] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[0] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[0] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[0] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[0] = sum;
    
    let x = composer.x_coordinates[1];
    let sum = 0;
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[1] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[1] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[1] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[1] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[1] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[1] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[1] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[1] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[1] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[1] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[1] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[1] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[1] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[1] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[1] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[1] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[1] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[1] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[1] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[1] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[1] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[1] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[1] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[1] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[1] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[1] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[1] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[1] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[1] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[1] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[1] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[1] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[1] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[1] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[1] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[1] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[1] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[1] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[1] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[1] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[1] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[1] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[1] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[1] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[1] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[1] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[1] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[1] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[1] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[1] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[1] = sum;
    
    let x = composer.x_coordinates[2];
    let sum = 0;
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[2] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[2] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[2] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[2] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[2] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[2] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[2] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[2] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[2] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[2] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[2] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[2] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[2] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[2] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[2] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[2] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[2] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[2] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[2] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[2] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[2] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[2] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[2] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[2] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[2] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[2] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[2] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[2] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[2] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[2] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[2] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[2] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[2] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[2] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[2] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[2] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[2] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[2] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[2] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[2] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[2] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[2] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[2] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[2] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[2] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[2] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[2] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[2] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[2] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[2] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[2] = sum;
    
    let x = composer.x_coordinates[3];
    let sum = 0;
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[3] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[3] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[3] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[3] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[3] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[3] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[3] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[3] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[3] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[3] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[3] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[3] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[3] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[3] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[3] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[3] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[3] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[3] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[3] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[3] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[3] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[3] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[3] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[3] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[3] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[3] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[3] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[3] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[3] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[3] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[3] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[3] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[3] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[3] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[3] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[3] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[3] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[3] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[3] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[3] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[3] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[3] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[3] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[3] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[3] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[3] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[3] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[3] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[3] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[3] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[3] = sum;
    
    let x = composer.x_coordinates[4];
    let sum = 0;
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[4] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[4] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[4] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[4] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[4] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[4] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[4] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[4] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[4] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[4] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[4] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[4] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[4] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[4] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[4] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[4] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[4] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[4] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[4] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[4] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[4] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[4] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[4] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[4] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[4] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[4] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[4] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[4] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[4] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[4] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[4] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[4] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[4] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[4] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[4] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[4] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[4] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[4] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[4] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[4] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[4] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[4] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[4] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[4] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[4] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[4] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[4] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[4] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[4] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[4] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[4] = sum;
    
    let x = composer.x_coordinates[5];
    let sum = 0;
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[5] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[5] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[5] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[5] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[5] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[5] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[5] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[5] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[5] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[5] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[5] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[5] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[5] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[5] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[5] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[5] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[5] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[5] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[5] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[5] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[5] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[5] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[5] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[5] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[5] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[5] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[5] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[5] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[5] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[5] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[5] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[5] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[5] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[5] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[5] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[5] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[5] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[5] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[5] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[5] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[5] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[5] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[5] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[5] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[5] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[5] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[5] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[5] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[5] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[5] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[5] = sum;
    
    let x = composer.x_coordinates[6];
    let sum = 0;
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[6] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[6] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[6] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[6] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[6] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[6] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[6] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[6] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[6] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[6] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[6] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[6] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[6] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[6] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[6] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[6] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[6] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[6] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[6] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[6] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[6] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[6] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[6] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[6] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[6] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[6] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[6] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[6] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[6] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[6] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[6] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[6] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[6] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[6] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[6] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[6] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[6] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[6] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[6] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[6] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[6] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[6] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[6] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[6] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[6] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[6] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[6] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[6] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[6] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[6] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[6] = sum;
    
    let x = composer.x_coordinates[7];
    let sum = 0;
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[7] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[7] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[7] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[7] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[7] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[7] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[7] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[7] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[7] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[7] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[7] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[7] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[7] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[7] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[7] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[7] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[7] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[7] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[7] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[7] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[7] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[7] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[7] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[7] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[7] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[7] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[7] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[7] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[7] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[7] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[7] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[7] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[7] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[7] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[7] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[7] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[7] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[7] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[7] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[7] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[7] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[7] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[7] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[7] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[7] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[7] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[7] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[7] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[7] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[7] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[7] = sum;
    
    let x = composer.x_coordinates[8];
    let sum = 0;
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[8] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[8] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[8] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[8] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[8] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[8] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[8] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[8] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[8] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[8] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[8] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[8] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[8] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[8] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[8] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[8] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[8] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[8] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[8] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[8] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[8] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[8] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[8] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[8] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[8] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[8] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[8] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[8] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[8] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[8] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[8] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[8] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[8] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[8] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[8] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[8] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[8] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[8] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[8] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[8] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[8] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[8] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[8] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[8] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[8] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[8] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[8] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[8] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[8] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[8] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[8] = sum;
    
    let x = composer.x_coordinates[9];
    let sum = 0;
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[9] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[9] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[9] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[9] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[9] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[9] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[9] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[9] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[9] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[9] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[9] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[9] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[9] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[9] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[9] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[9] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[9] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[9] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[9] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[9] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[9] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[9] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[9] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[9] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[9] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[9] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[9] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[9] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[9] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[9] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[9] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[9] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[9] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[9] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[9] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[9] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[9] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[9] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[9] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[9] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[9] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[9] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[9] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[9] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[9] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[9] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[9] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[9] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[9] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[9] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[9] = sum;
    
    let x = composer.x_coordinates[10];
    let sum = 0;
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[10] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[10] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[10] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[10] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[10] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[10] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[10] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[10] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[10] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[10] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[10] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[10] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[10] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[10] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[10] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[10] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[10] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[10] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[10] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[10] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[10] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[10] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[10] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[10] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[10] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[10] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[10] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[10] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[10] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[10] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[10] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[10] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[10] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[10] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[10] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[10] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[10] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[10] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[10] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[10] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[10] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[10] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[10] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[10] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[10] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[10] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[10] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[10] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[10] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[10] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[10] = sum;
    
    let x = composer.x_coordinates[11];
    let sum = 0;
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[11] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[11] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[11] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[11] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[11] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[11] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[11] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[11] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[11] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[11] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[11] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[11] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[11] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[11] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[11] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[11] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[11] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[11] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[11] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[11] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[11] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[11] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[11] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[11] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[11] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[11] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[11] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[11] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[11] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[11] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[11] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[11] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[11] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[11] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[11] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[11] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[11] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[11] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[11] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[11] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[11] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[11] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[11] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[11] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[11] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[11] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[11] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[11] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[11] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[11] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[11] = sum;
    
    let x = composer.x_coordinates[12];
    let sum = 0;
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[12] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[12] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[12] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[12] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[12] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[12] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[12] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[12] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[12] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[12] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[12] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[12] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[12] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[12] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[12] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[12] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[12] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[12] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[12] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[12] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[12] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[12] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[12] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[12] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[12] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[12] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[12] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[12] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[12] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[12] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[12] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[12] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[12] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[12] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[12] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[12] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[12] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[12] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[12] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[12] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[12] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[12] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[12] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[12] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[12] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[12] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[12] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[12] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[12] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[12] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[12] = sum;
    
    let x = composer.x_coordinates[13];
    let sum = 0;
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[13] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[13] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[13] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[13] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[13] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[13] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[13] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[13] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[13] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[13] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[13] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[13] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[13] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[13] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[13] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[13] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[13] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[13] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[13] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[13] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[13] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[13] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[13] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[13] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[13] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[13] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[13] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[13] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[13] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[13] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[13] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[13] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[13] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[13] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[13] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[13] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[13] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[13] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[13] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[13] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[13] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[13] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[13] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[13] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[13] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[13] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[13] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[13] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[13] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[13] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[13] = sum;
    
    let x = composer.x_coordinates[14];
    let sum = 0;
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[14] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[14] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[14] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[14] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[14] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[14] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[14] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[14] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[14] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[14] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[14] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[14] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[14] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[14] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[14] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[14] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[14] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[14] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[14] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[14] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[14] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[14] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[14] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[14] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[14] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[14] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[14] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[14] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[14] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[14] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[14] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[14] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[14] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[14] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[14] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[14] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[14] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[14] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[14] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[14] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[14] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[14] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[14] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[14] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[14] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[14] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[14] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[14] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[14] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[14] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[14] = sum;
    
    let x = composer.x_coordinates[15];
    let sum = 0;
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[15] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[15] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[15] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[15] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[15] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[15] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[15] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[15] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[15] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[15] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[15] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[15] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[15] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[15] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[15] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[15] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[15] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[15] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[15] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[15] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[15] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[15] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[15] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[15] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[15] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[15] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[15] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[15] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[15] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[15] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[15] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[15] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[15] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[15] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[15] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[15] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[15] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[15] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[15] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[15] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[15] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[15] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[15] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[15] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[15] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[15] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[15] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[15] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[15] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[15] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[15] = sum;
    
    let x = composer.x_coordinates[16];
    let sum = 0;
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[16] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[16] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[16] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[16] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[16] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[16] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[16] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[16] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[16] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[16] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[16] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[16] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[16] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[16] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[16] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[16] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[16] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[16] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[16] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[16] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[16] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[16] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[16] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[16] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[16] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[16] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[16] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[16] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[16] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[16] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[16] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[16] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[16] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[16] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[16] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[16] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[16] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[16] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[16] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[16] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[16] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[16] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[16] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[16] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[16] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[16] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[16] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[16] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[16] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[16] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[16] = sum;
    
    let x = composer.x_coordinates[17];
    let sum = 0;
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[17] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[17] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[17] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[17] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[17] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[17] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[17] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[17] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[17] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[17] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[17] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[17] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[17] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[17] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[17] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[17] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[17] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[17] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[17] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[17] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[17] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[17] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[17] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[17] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[17] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[17] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[17] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[17] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[17] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[17] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[17] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[17] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[17] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[17] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[17] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[17] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[17] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[17] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[17] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[17] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[17] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[17] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[17] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[17] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[17] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[17] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[17] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[17] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[17] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[17] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[17] = sum;
    
    let x = composer.x_coordinates[18];
    let sum = 0;
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[18] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[18] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[18] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[18] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[18] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[18] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[18] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[18] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[18] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[18] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[18] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[18] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[18] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[18] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[18] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[18] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[18] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[18] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[18] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[18] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[18] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[18] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[18] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[18] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[18] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[18] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[18] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[18] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[18] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[18] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[18] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[18] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[18] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[18] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[18] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[18] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[18] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[18] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[18] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[18] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[18] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[18] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[18] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[18] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[18] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[18] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[18] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[18] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[18] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[18] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[18] = sum;
    
    let x = composer.x_coordinates[19];
    let sum = 0;
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[19] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[19] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[19] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[19] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[19] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[19] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[19] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[19] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[19] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[19] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[19] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[19] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[19] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[19] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[19] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[19] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[19] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[19] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[19] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[19] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[19] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[19] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[19] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[19] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[19] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[19] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[19] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[19] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[19] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[19] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[19] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[19] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[19] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[19] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[19] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[19] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[19] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[19] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[19] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[19] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[19] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[19] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[19] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[19] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[19] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[19] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[19] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[19] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[19] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[19] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[19] = sum;
    
    let x = composer.x_coordinates[20];
    let sum = 0;
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[20] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[20] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[20] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[20] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[20] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[20] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[20] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[20] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[20] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[20] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[20] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[20] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[20] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[20] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[20] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[20] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[20] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[20] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[20] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[20] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[20] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[20] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[20] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[20] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[20] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[20] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[20] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[20] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[20] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[20] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[20] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[20] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[20] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[20] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[20] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[20] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[20] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[20] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[20] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[20] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[20] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[20] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[20] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[20] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[20] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[20] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[20] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[20] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[20] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[20] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[20] = sum;
    
    let x = composer.x_coordinates[21];
    let sum = 0;
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[21] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[21] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[21] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[21] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[21] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[21] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[21] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[21] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[21] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[21] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[21] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[21] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[21] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[21] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[21] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[21] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[21] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[21] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[21] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[21] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[21] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[21] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[21] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[21] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[21] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[21] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[21] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[21] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[21] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[21] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[21] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[21] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[21] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[21] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[21] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[21] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[21] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[21] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[21] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[21] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[21] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[21] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[21] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[21] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[21] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[21] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[21] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[21] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[21] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[21] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[21] = sum;
    
    let x = composer.x_coordinates[22];
    let sum = 0;
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[22] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[22] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[22] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[22] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[22] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[22] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[22] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[22] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[22] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[22] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[22] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[22] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[22] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[22] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[22] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[22] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[22] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[22] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[22] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[22] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[22] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[22] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[22] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[22] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[22] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[22] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[22] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[22] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[22] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[22] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[22] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[22] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[22] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[22] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[22] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[22] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[22] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[22] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[22] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[22] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[22] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[22] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[22] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[22] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[22] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[22] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[22] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[22] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[22] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[22] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[22] = sum;
    
    let x = composer.x_coordinates[23];
    let sum = 0;
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[23] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[23] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[23] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[23] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[23] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[23] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[23] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[23] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[23] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[23] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[23] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[23] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[23] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[23] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[23] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[23] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[23] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[23] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[23] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[23] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[23] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[23] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[23] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[23] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[23] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[23] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[23] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[23] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[23] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[23] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[23] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[23] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[23] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[23] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[23] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[23] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[23] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[23] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[23] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[23] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[23] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[23] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[23] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[23] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[23] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[23] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[23] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[23] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[23] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[23] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[23] = sum;
    
    let x = composer.x_coordinates[24];
    let sum = 0;
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[24] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[24] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[24] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[24] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[24] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[24] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[24] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[24] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[24] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[24] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[24] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[24] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[24] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[24] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[24] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[24] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[24] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[24] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[24] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[24] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[24] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[24] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[24] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[24] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[24] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[24] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[24] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[24] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[24] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[24] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[24] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[24] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[24] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[24] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[24] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[24] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[24] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[24] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[24] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[24] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[24] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[24] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[24] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[24] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[24] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[24] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[24] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[24] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[24] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[24] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[24] = sum;
    
    let x = composer.x_coordinates[25];
    let sum = 0;
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[25] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[25] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[25] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[25] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[25] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[25] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[25] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[25] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[25] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[25] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[25] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[25] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[25] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[25] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[25] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[25] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[25] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[25] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[25] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[25] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[25] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[25] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[25] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[25] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[25] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[25] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[25] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[25] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[25] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[25] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[25] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[25] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[25] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[25] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[25] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[25] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[25] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[25] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[25] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[25] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[25] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[25] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[25] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[25] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[25] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[25] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[25] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[25] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[25] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[25] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[25] = sum;
    
    let x = composer.x_coordinates[26];
    let sum = 0;
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[26] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[26] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[26] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[26] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[26] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[26] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[26] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[26] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[26] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[26] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[26] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[26] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[26] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[26] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[26] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[26] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[26] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[26] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[26] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[26] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[26] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[26] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[26] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[26] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[26] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[26] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[26] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[26] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[26] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[26] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[26] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[26] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[26] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[26] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[26] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[26] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[26] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[26] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[26] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[26] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[26] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[26] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[26] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[26] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[26] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[26] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[26] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[26] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[26] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[26] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[26] = sum;
    
    let x = composer.x_coordinates[27];
    let sum = 0;
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[27] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[27] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[27] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[27] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[27] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[27] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[27] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[27] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[27] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[27] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[27] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[27] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[27] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[27] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[27] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[27] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[27] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[27] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[27] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[27] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[27] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[27] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[27] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[27] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[27] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[27] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[27] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[27] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[27] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[27] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[27] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[27] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[27] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[27] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[27] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[27] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[27] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[27] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[27] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[27] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[27] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[27] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[27] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[27] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[27] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[27] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[27] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[27] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[27] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[27] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[27] = sum;
    
    let x = composer.x_coordinates[28];
    let sum = 0;
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[28] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[28] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[28] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[28] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[28] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[28] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[28] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[28] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[28] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[28] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[28] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[28] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[28] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[28] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[28] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[28] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[28] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[28] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[28] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[28] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[28] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[28] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[28] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[28] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[28] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[28] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[28] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[28] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[28] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[28] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[28] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[28] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[28] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[28] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[28] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[28] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[28] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[28] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[28] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[28] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[28] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[28] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[28] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[28] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[28] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[28] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[28] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[28] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[28] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[28] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[28] = sum;
    
    let x = composer.x_coordinates[29];
    let sum = 0;
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[29] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[29] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[29] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[29] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[29] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[29] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[29] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[29] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[29] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[29] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[29] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[29] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[29] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[29] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[29] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[29] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[29] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[29] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[29] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[29] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[29] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[29] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[29] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[29] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[29] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[29] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[29] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[29] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[29] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[29] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[29] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[29] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[29] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[29] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[29] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[29] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[29] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[29] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[29] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[29] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[29] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[29] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[29] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[29] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[29] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[29] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[29] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[29] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[29] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[29] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[29] = sum;
    
    let x = composer.x_coordinates[30];
    let sum = 0;
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[30] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[30] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[30] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[30] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[30] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[30] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[30] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[30] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[30] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[30] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[30] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[30] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[30] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[30] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[30] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[30] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[30] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[30] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[30] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[30] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[30] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[30] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[30] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[30] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[30] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[30] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[30] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[30] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[30] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[30] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[30] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[30] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[30] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[30] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[30] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[30] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[30] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[30] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[30] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[30] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[30] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[30] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[30] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[30] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[30] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[30] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[30] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[30] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[30] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[30] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[30] = sum;
    
    let x = composer.x_coordinates[31];
    let sum = 0;
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[31] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[31] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[31] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[31] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[31] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[31] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[31] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[31] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[31] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[31] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[31] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[31] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[31] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[31] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[31] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[31] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[31] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[31] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[31] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[31] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[31] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[31] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[31] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[31] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[31] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[31] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[31] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[31] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[31] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[31] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[31] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[31] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[31] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[31] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[31] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[31] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[31] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[31] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[31] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[31] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[31] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[31] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[31] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[31] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[31] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[31] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[31] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[31] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[31] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[31] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[31] = sum;
    
    let x = composer.x_coordinates[32];
    let sum = 0;
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[32] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[32] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[32] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[32] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[32] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[32] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[32] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[32] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[32] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[32] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[32] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[32] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[32] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[32] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[32] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[32] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[32] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[32] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[32] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[32] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[32] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[32] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[32] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[32] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[32] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[32] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[32] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[32] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[32] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[32] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[32] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[32] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[32] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[32] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[32] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[32] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[32] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[32] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[32] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[32] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[32] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[32] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[32] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[32] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[32] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[32] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[32] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[32] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[32] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[32] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[32] = sum;
    
    let x = composer.x_coordinates[33];
    let sum = 0;
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[33] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[33] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[33] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[33] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[33] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[33] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[33] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[33] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[33] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[33] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[33] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[33] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[33] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[33] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[33] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[33] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[33] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[33] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[33] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[33] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[33] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[33] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[33] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[33] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[33] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[33] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[33] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[33] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[33] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[33] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[33] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[33] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[33] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[33] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[33] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[33] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[33] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[33] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[33] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[33] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[33] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[33] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[33] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[33] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[33] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[33] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[33] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[33] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[33] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[33] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[33] = sum;
    
    let x = composer.x_coordinates[34];
    let sum = 0;
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[34] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[34] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[34] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[34] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[34] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[34] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[34] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[34] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[34] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[34] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[34] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[34] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[34] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[34] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[34] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[34] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[34] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[34] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[34] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[34] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[34] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[34] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[34] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[34] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[34] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[34] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[34] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[34] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[34] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[34] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[34] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[34] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[34] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[34] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[34] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[34] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[34] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[34] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[34] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[34] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[34] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[34] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[34] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[34] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[34] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[34] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[34] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[34] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[34] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[34] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[34] = sum;
    
    let x = composer.x_coordinates[35];
    let sum = 0;
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[35] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[35] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[35] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[35] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[35] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[35] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[35] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[35] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[35] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[35] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[35] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[35] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[35] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[35] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[35] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[35] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[35] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[35] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[35] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[35] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[35] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[35] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[35] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[35] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[35] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[35] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[35] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[35] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[35] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[35] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[35] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[35] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[35] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[35] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[35] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[35] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[35] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[35] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[35] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[35] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[35] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[35] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[35] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[35] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[35] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[35] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[35] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[35] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[35] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[35] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[35] = sum;
    
    let x = composer.x_coordinates[36];
    let sum = 0;
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[36] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[36] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[36] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[36] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[36] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[36] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[36] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[36] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[36] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[36] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[36] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[36] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[36] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[36] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[36] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[36] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[36] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[36] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[36] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[36] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[36] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[36] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[36] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[36] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[36] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[36] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[36] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[36] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[36] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[36] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[36] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[36] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[36] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[36] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[36] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[36] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[36] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[36] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[36] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[36] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[36] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[36] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[36] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[36] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[36] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[36] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[36] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[36] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[36] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[36] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[36] = sum;
    
    let x = composer.x_coordinates[37];
    let sum = 0;
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[37] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[37] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[37] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[37] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[37] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[37] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[37] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[37] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[37] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[37] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[37] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[37] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[37] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[37] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[37] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[37] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[37] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[37] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[37] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[37] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[37] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[37] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[37] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[37] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[37] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[37] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[37] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[37] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[37] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[37] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[37] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[37] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[37] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[37] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[37] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[37] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[37] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[37] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[37] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[37] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[37] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[37] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[37] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[37] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[37] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[37] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[37] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[37] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[37] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[37] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[37] = sum;
    
    let x = composer.x_coordinates[38];
    let sum = 0;
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[38] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[38] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[38] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[38] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[38] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[38] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[38] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[38] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[38] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[38] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[38] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[38] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[38] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[38] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[38] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[38] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[38] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[38] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[38] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[38] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[38] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[38] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[38] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[38] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[38] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[38] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[38] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[38] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[38] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[38] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[38] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[38] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[38] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[38] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[38] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[38] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[38] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[38] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[38] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[38] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[38] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[38] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[38] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[38] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[38] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[38] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[38] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[38] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[38] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[38] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[38] = sum;
    
    let x = composer.x_coordinates[39];
    let sum = 0;
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[39] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[39] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[39] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[39] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[39] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[39] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[39] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[39] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[39] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[39] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[39] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[39] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[39] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[39] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[39] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[39] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[39] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[39] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[39] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[39] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[39] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[39] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[39] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[39] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[39] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[39] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[39] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[39] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[39] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[39] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[39] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[39] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[39] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[39] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[39] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[39] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[39] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[39] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[39] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[39] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[39] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[39] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[39] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[39] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[39] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[39] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[39] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[39] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[39] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[39] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[39] = sum;
    
    let x = composer.x_coordinates[40];
    let sum = 0;
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[40] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[40] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[40] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[40] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[40] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[40] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[40] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[40] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[40] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[40] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[40] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[40] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[40] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[40] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[40] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[40] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[40] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[40] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[40] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[40] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[40] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[40] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[40] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[40] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[40] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[40] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[40] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[40] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[40] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[40] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[40] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[40] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[40] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[40] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[40] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[40] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[40] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[40] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[40] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[40] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[40] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[40] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[40] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[40] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[40] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[40] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[40] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[40] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[40] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[40] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[40] = sum;
    
    let x = composer.x_coordinates[41];
    let sum = 0;
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[41] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[41] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[41] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[41] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[41] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[41] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[41] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[41] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[41] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[41] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[41] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[41] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[41] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[41] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[41] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[41] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[41] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[41] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[41] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[41] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[41] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[41] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[41] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[41] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[41] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[41] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[41] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[41] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[41] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[41] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[41] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[41] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[41] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[41] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[41] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[41] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[41] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[41] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[41] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[41] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[41] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[41] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[41] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[41] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[41] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[41] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[41] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[41] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[41] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[41] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[41] = sum;
    
    let x = composer.x_coordinates[42];
    let sum = 0;
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[42] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[42] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[42] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[42] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[42] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[42] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[42] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[42] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[42] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[42] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[42] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[42] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[42] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[42] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[42] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[42] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[42] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[42] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[42] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[42] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[42] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[42] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[42] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[42] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[42] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[42] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[42] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[42] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[42] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[42] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[42] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[42] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[42] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[42] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[42] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[42] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[42] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[42] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[42] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[42] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[42] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[42] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[42] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[42] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[42] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[42] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[42] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[42] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[42] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[42] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[42] = sum;
    
    let x = composer.x_coordinates[43];
    let sum = 0;
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[43] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[43] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[43] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[43] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[43] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[43] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[43] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[43] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[43] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[43] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[43] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[43] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[43] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[43] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[43] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[43] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[43] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[43] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[43] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[43] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[43] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[43] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[43] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[43] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[43] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[43] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[43] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[43] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[43] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[43] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[43] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[43] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[43] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[43] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[43] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[43] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[43] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[43] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[43] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[43] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[43] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[43] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[43] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[43] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[43] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[43] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[43] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[43] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[43] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[43] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[43] = sum;
    
    let x = composer.x_coordinates[44];
    let sum = 0;
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[44] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[44] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[44] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[44] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[44] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[44] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[44] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[44] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[44] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[44] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[44] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[44] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[44] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[44] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[44] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[44] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[44] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[44] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[44] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[44] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[44] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[44] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[44] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[44] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[44] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[44] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[44] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[44] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[44] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[44] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[44] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[44] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[44] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[44] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[44] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[44] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[44] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[44] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[44] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[44] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[44] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[44] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[44] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[44] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[44] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[44] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[44] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[44] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[44] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[44] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[44] = sum;
    
    let x = composer.x_coordinates[45];
    let sum = 0;
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[45] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[45] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[45] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[45] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[45] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[45] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[45] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[45] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[45] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[45] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[45] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[45] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[45] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[45] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[45] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[45] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[45] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[45] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[45] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[45] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[45] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[45] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[45] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[45] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[45] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[45] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[45] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[45] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[45] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[45] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[45] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[45] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[45] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[45] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[45] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[45] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[45] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[45] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[45] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[45] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[45] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[45] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[45] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[45] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[45] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[45] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[45] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[45] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[45] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[45] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[45] = sum;
    
    let x = composer.x_coordinates[46];
    let sum = 0;
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[46] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[46] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[46] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[46] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[46] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[46] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[46] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[46] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[46] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[46] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[46] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[46] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[46] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[46] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[46] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[46] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[46] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[46] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[46] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[46] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[46] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[46] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[46] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[46] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[46] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[46] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[46] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[46] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[46] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[46] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[46] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[46] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[46] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[46] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[46] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[46] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[46] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[46] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[46] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[46] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[46] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[46] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[46] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[46] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[46] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[46] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[46] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[46] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[46] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[46] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[46] = sum;
    
    let x = composer.x_coordinates[47];
    let sum = 0;
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[47] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[47] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[47] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[47] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[47] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[47] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[47] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[47] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[47] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[47] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[47] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[47] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[47] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[47] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[47] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[47] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[47] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[47] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[47] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[47] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[47] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[47] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[47] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[47] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[47] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[47] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[47] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[47] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[47] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[47] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[47] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[47] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[47] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[47] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[47] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[47] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[47] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[47] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[47] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[47] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[47] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[47] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[47] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[47] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[47] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[47] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[47] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[47] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[47] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[47] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[47] = sum;
    
    let x = composer.x_coordinates[48];
    let sum = 0;
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[48] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[48] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[48] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[48] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[48] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[48] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[48] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[48] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[48] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[48] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[48] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[48] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[48] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[48] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[48] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[48] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[48] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[48] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[48] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[48] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[48] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[48] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[48] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[48] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[48] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[48] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[48] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[48] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[48] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[48] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[48] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[48] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[48] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[48] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[48] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[48] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[48] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[48] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[48] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[48] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[48] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[48] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[48] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[48] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[48] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[48] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[48] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[48] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[48] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[48] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[48] = sum;
    
    let x = composer.x_coordinates[49];
    let sum = 0;
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[49] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[49] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[49] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[49] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[49] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[49] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[49] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[49] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[49] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[49] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[49] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[49] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[49] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[49] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[49] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[49] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[49] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[49] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[49] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[49] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[49] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[49] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[49] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[49] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[49] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[49] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[49] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[49] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[49] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[49] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[49] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[49] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[49] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[49] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[49] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[49] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[49] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[49] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[49] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[49] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[49] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[49] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[49] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[49] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[49] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[49] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[49] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[49] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[49] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[49] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[49] = sum;
    
    let x = composer.x_coordinates[50];
    let sum = 0;
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[50] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[50] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[50] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[50] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[50] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[50] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[50] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[50] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[50] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[50] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[50] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[50] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[50] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[50] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[50] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[50] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[50] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[50] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[50] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[50] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[50] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[50] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[50] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[50] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[50] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[50] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[50] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[50] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[50] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[50] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[50] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[50] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[50] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[50] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[50] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[50] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[50] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[50] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[50] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[50] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[50] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[50] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[50] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[50] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[50] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[50] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[50] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[50] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[50] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[50] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[50] = sum;
    
    let x = composer.x_coordinates[51];
    let sum = 0;
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[51] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[51] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[51] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[51] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[51] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[51] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[51] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[51] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[51] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[51] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[51] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[51] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[51] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[51] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[51] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[51] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[51] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[51] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[51] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[51] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[51] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[51] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[51] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[51] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[51] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[51] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[51] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[51] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[51] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[51] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[51] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[51] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[51] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[51] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[51] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[51] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[51] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[51] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[51] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[51] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[51] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[51] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[51] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[51] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[51] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[51] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[51] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[51] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[51] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[51] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[51] = sum;
    
    let x = composer.x_coordinates[52];
    let sum = 0;
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[52] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[52] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[52] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[52] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[52] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[52] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[52] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[52] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[52] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[52] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[52] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[52] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[52] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[52] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[52] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[52] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[52] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[52] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[52] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[52] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[52] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[52] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[52] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[52] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[52] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[52] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[52] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[52] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[52] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[52] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[52] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[52] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[52] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[52] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[52] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[52] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[52] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[52] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[52] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[52] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[52] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[52] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[52] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[52] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[52] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[52] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[52] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[52] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[52] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[52] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[52] = sum;
    
    let x = composer.x_coordinates[53];
    let sum = 0;
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[0]) / (x - z_curr)) * cc_trace_curr[0] +
        ((next[53] - ood_main_frame.next[0]) / (x - z_next)) * cc_trace_next[0]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[1]) / (x - z_curr)) * cc_trace_curr[1] +
        ((next[53] - ood_main_frame.next[1]) / (x - z_next)) * cc_trace_next[1]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[2]) / (x - z_curr)) * cc_trace_curr[2] +
        ((next[53] - ood_main_frame.next[2]) / (x - z_next)) * cc_trace_next[2]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[3]) / (x - z_curr)) * cc_trace_curr[3] +
        ((next[53] - ood_main_frame.next[3]) / (x - z_next)) * cc_trace_next[3]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[4]) / (x - z_curr)) * cc_trace_curr[4] +
        ((next[53] - ood_main_frame.next[4]) / (x - z_next)) * cc_trace_next[4]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[5]) / (x - z_curr)) * cc_trace_curr[5] +
        ((next[53] - ood_main_frame.next[5]) / (x - z_next)) * cc_trace_next[5]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[6]) / (x - z_curr)) * cc_trace_curr[6] +
        ((next[53] - ood_main_frame.next[6]) / (x - z_next)) * cc_trace_next[6]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[7]) / (x - z_curr)) * cc_trace_curr[7] +
        ((next[53] - ood_main_frame.next[7]) / (x - z_next)) * cc_trace_next[7]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[8]) / (x - z_curr)) * cc_trace_curr[8] +
        ((next[53] - ood_main_frame.next[8]) / (x - z_next)) * cc_trace_next[8]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[9]) / (x - z_curr)) * cc_trace_curr[9] +
        ((next[53] - ood_main_frame.next[9]) / (x - z_next)) * cc_trace_next[9]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[10]) / (x - z_curr)) * cc_trace_curr[10] +
        ((next[53] - ood_main_frame.next[10]) / (x - z_next)) * cc_trace_next[10]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[11]) / (x - z_curr)) * cc_trace_curr[11] +
        ((next[53] - ood_main_frame.next[11]) / (x - z_next)) * cc_trace_next[11]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[12]) / (x - z_curr)) * cc_trace_curr[12] +
        ((next[53] - ood_main_frame.next[12]) / (x - z_next)) * cc_trace_next[12]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[13]) / (x - z_curr)) * cc_trace_curr[13] +
        ((next[53] - ood_main_frame.next[13]) / (x - z_next)) * cc_trace_next[13]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[14]) / (x - z_curr)) * cc_trace_curr[14] +
        ((next[53] - ood_main_frame.next[14]) / (x - z_next)) * cc_trace_next[14]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[15]) / (x - z_curr)) * cc_trace_curr[15] +
        ((next[53] - ood_main_frame.next[15]) / (x - z_next)) * cc_trace_next[15]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[16]) / (x - z_curr)) * cc_trace_curr[16] +
        ((next[53] - ood_main_frame.next[16]) / (x - z_next)) * cc_trace_next[16]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[17]) / (x - z_curr)) * cc_trace_curr[17] +
        ((next[53] - ood_main_frame.next[17]) / (x - z_next)) * cc_trace_next[17]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[18]) / (x - z_curr)) * cc_trace_curr[18] +
        ((next[53] - ood_main_frame.next[18]) / (x - z_next)) * cc_trace_next[18]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[19]) / (x - z_curr)) * cc_trace_curr[19] +
        ((next[53] - ood_main_frame.next[19]) / (x - z_next)) * cc_trace_next[19]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[20]) / (x - z_curr)) * cc_trace_curr[20] +
        ((next[53] - ood_main_frame.next[20]) / (x - z_next)) * cc_trace_next[20]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[21]) / (x - z_curr)) * cc_trace_curr[21] +
        ((next[53] - ood_main_frame.next[21]) / (x - z_next)) * cc_trace_next[21]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[22]) / (x - z_curr)) * cc_trace_curr[22] +
        ((next[53] - ood_main_frame.next[22]) / (x - z_next)) * cc_trace_next[22]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[23]) / (x - z_curr)) * cc_trace_curr[23] +
        ((next[53] - ood_main_frame.next[23]) / (x - z_next)) * cc_trace_next[23]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[24]) / (x - z_curr)) * cc_trace_curr[24] +
        ((next[53] - ood_main_frame.next[24]) / (x - z_next)) * cc_trace_next[24]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[25]) / (x - z_curr)) * cc_trace_curr[25] +
        ((next[53] - ood_main_frame.next[25]) / (x - z_next)) * cc_trace_next[25]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[26]) / (x - z_curr)) * cc_trace_curr[26] +
        ((next[53] - ood_main_frame.next[26]) / (x - z_next)) * cc_trace_next[26]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[27]) / (x - z_curr)) * cc_trace_curr[27] +
        ((next[53] - ood_main_frame.next[27]) / (x - z_next)) * cc_trace_next[27]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[28]) / (x - z_curr)) * cc_trace_curr[28] +
        ((next[53] - ood_main_frame.next[28]) / (x - z_next)) * cc_trace_next[28]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[29]) / (x - z_curr)) * cc_trace_curr[29] +
        ((next[53] - ood_main_frame.next[29]) / (x - z_next)) * cc_trace_next[29]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[30]) / (x - z_curr)) * cc_trace_curr[30] +
        ((next[53] - ood_main_frame.next[30]) / (x - z_next)) * cc_trace_next[30]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[31]) / (x - z_curr)) * cc_trace_curr[31] +
        ((next[53] - ood_main_frame.next[31]) / (x - z_next)) * cc_trace_next[31]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[32]) / (x - z_curr)) * cc_trace_curr[32] +
        ((next[53] - ood_main_frame.next[32]) / (x - z_next)) * cc_trace_next[32]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[33]) / (x - z_curr)) * cc_trace_curr[33] +
        ((next[53] - ood_main_frame.next[33]) / (x - z_next)) * cc_trace_next[33]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[34]) / (x - z_curr)) * cc_trace_curr[34] +
        ((next[53] - ood_main_frame.next[34]) / (x - z_next)) * cc_trace_next[34]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[35]) / (x - z_curr)) * cc_trace_curr[35] +
        ((next[53] - ood_main_frame.next[35]) / (x - z_next)) * cc_trace_next[35]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[36]) / (x - z_curr)) * cc_trace_curr[36] +
        ((next[53] - ood_main_frame.next[36]) / (x - z_next)) * cc_trace_next[36]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[37]) / (x - z_curr)) * cc_trace_curr[37] +
        ((next[53] - ood_main_frame.next[37]) / (x - z_next)) * cc_trace_next[37]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[38]) / (x - z_curr)) * cc_trace_curr[38] +
        ((next[53] - ood_main_frame.next[38]) / (x - z_next)) * cc_trace_next[38]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[39]) / (x - z_curr)) * cc_trace_curr[39] +
        ((next[53] - ood_main_frame.next[39]) / (x - z_next)) * cc_trace_next[39]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[40]) / (x - z_curr)) * cc_trace_curr[40] +
        ((next[53] - ood_main_frame.next[40]) / (x - z_next)) * cc_trace_next[40]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[41]) / (x - z_curr)) * cc_trace_curr[41] +
        ((next[53] - ood_main_frame.next[41]) / (x - z_next)) * cc_trace_next[41]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[42]) / (x - z_curr)) * cc_trace_curr[42] +
        ((next[53] - ood_main_frame.next[42]) / (x - z_next)) * cc_trace_next[42]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[43]) / (x - z_curr)) * cc_trace_curr[43] +
        ((next[53] - ood_main_frame.next[43]) / (x - z_next)) * cc_trace_next[43]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[44]) / (x - z_curr)) * cc_trace_curr[44] +
        ((next[53] - ood_main_frame.next[44]) / (x - z_next)) * cc_trace_next[44]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[45]) / (x - z_curr)) * cc_trace_curr[45] +
        ((next[53] - ood_main_frame.next[45]) / (x - z_next)) * cc_trace_next[45]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[46]) / (x - z_curr)) * cc_trace_curr[46] +
        ((next[53] - ood_main_frame.next[46]) / (x - z_next)) * cc_trace_next[46]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[47]) / (x - z_curr)) * cc_trace_curr[47] +
        ((next[53] - ood_main_frame.next[47]) / (x - z_next)) * cc_trace_next[47]
    );
        
    let sum = sum + (
        ((curr[53] - ood_main_frame.current[48]) / (x - z_curr)) * cc_trace_curr[48] +
        ((next[53] - ood_main_frame.next[48]) / (x - z_next)) * cc_trace_next[48]
    );
        
    assert result[53] = sum;
    

    // TODO: Compose columns of the aux segments

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
