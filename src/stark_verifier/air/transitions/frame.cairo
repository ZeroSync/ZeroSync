from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy

// Main constraint identifiers
const INST = 16;
const DST_ADDR = 17;
const OP0_ADDR = 18;
const OP1_ADDR = 19;
const NEXT_AP = 20;
const NEXT_FP = 21;
const NEXT_PC_1 = 22;
const NEXT_PC_2 = 23;
const T0 = 24;
const T1 = 25;
const MUL_1 = 26;
const MUL_2 = 27;
const CALL_1 = 28;
const CALL_2 = 29;
const ASSERT_EQ = 30;

// MAIN TRACE LAYOUT
// -----------------------------------------------------------------------------------------
//  A.  flags   (16) : Decoded instruction flags
//  B.  res     (1)  : Res value
//  C.  mem_p   (2)  : Temporary memory pointers (ap and fp)
//  D.  mem_a   (4)  : Memory addresses (pc, dst_addr, op0_addr, op1_addr)
//  E.  mem_v   (4)  : Memory values (inst, dst, op0, op1)
//  F.  offsets (3)  : (off_dst, off_op0, off_op1)
//  G.  derived (3)  : (t0, t1, mul)
//
//  A                B C  D    E    F   G
// ├xxxxxxxxxxxxxxxx|x|xx|xxxx|xxxx|xxx|xxx┤

const FLAG_TRACE_OFFSET = 0;
const RES_TRACE_OFFSET = 16;
const MEM_P_TRACE_OFFSET = 17;
const MEM_A_TRACE_OFFSET = 19;
const MEM_V_TRACE_OFFSET = 23;
const DERIVED_TRACE_OFFSET = 30;
const SELECTOR_TRACE_OFFSET = 33;
const POS_FLAGS = 48;

const NUM_FLAGS = 16;

const A_M_PRIME_OFFSET = 0;
const A_M_PRIME_WIDTH = 4;

const V_M_PRIME_OFFSET = 4;
const V_M_PRIME_WIDTH = 4;

const P_M_OFFSET = 8;
const P_M_WIDTH = 4;

const MEM_A_TRACE_WIDTH = 4;
const MEM_V_TRACE_WIDTH = 4;

const A_RC_PRIME_OFFSET = 12;
const A_RC_PRIME_WIDTH = 3;

const OFF_X_TRACE_OFFSET = 27;
const OFF_X_TRACE_WIDTH = 3;

func bias(offset) -> felt{
    return offset - 2**15;
}

struct EvaluationFrame {
    current_len: felt,
    current: felt*,
    next_len: felt,
    next: felt*,
}

func evaluate_transition(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*,
) {
    alloc_locals;
    let (tmp_evaluations) = alloc();
    evaluate_instr_constraints(ood_main_trace_frame, tmp_evaluations);
    evaluate_operand_constraints(ood_main_trace_frame, tmp_evaluations);
    evaluate_register_constraints(ood_main_trace_frame, tmp_evaluations);
    evaluate_opcode_constraints(ood_main_trace_frame, tmp_evaluations);
    enforce_selector(ood_main_trace_frame, tmp_evaluations, t_evaluations1);

    return ();
}

func evaluate_instr_constraints(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*
){
    let curr = ood_main_trace_frame.current;
    
    // Bit constraints
    assert t_evaluations1[0] = curr[0] * (curr[0] - 1);
    assert t_evaluations1[1] = curr[1] * (curr[1] - 1);
    assert t_evaluations1[2] = curr[2] * (curr[2] - 1);
    assert t_evaluations1[3] = curr[3] * (curr[3] - 1);

    assert t_evaluations1[4] = curr[4] * (curr[4] - 1);
    assert t_evaluations1[5] = curr[5] * (curr[5] - 1);
    assert t_evaluations1[6] = curr[6] * (curr[6] - 1);
    assert t_evaluations1[7] = curr[7] * (curr[7] - 1);
    
    assert t_evaluations1[8] = curr[8] * (curr[8] - 1);
    assert t_evaluations1[9] = curr[9] * (curr[9] - 1);
    assert t_evaluations1[10] = curr[10] * (curr[10] - 1);
    assert t_evaluations1[11] = curr[11] * (curr[11] - 1);

    assert t_evaluations1[12] = curr[12] * (curr[12] - 1);
    assert t_evaluations1[13] = curr[13] * (curr[13] - 1);
    assert t_evaluations1[14] = curr[14] * (curr[14] - 1);
    assert t_evaluations1[15] = curr[15];

    // Instruction unpacking
    let b15 = 2**15;
    let b16 = 2**16;
    let b32 = 2**32;
    let b48 = 2**48;
    
    let a = curr[0] +
     2**1 * curr[1] +
     2**2 * curr[2] +
     2**3 * curr[3] +
     2**4 * curr[4] +
     2**5 * curr[5] +
     2**6 * curr[6] +
     2**7 * curr[7] +
     2**8 * curr[8] +
     2**9 * curr[9] +
     2**10 * curr[10] +
     2**11 * curr[11] +
     2**12 * curr[12] +
     2**13 * curr[13] +
     2**14 * curr[14];

    let curr_off_dst = bias(curr[0 + OFF_X_TRACE_OFFSET ]);
    let curr_off_op0 = bias(curr[1 + OFF_X_TRACE_OFFSET ]);
    let curr_off_op1 = bias(curr[2 + OFF_X_TRACE_OFFSET ]);
    let curr_inst = curr[0 + MEM_V_TRACE_OFFSET];
    assert t_evaluations1[INST] = (curr_off_dst + b15) + 
        b16 * (curr_off_op0 + b15) + 
        b32 * (curr_off_op1 + b15) + 
        b48 * a - curr_inst;
    return();
}

func evaluate_operand_constraints(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*
) {
    let curr = ood_main_trace_frame.current;

    let curr_ap = curr[0 + MEM_P_TRACE_OFFSET];
    let curr_fp = curr[1 + MEM_P_TRACE_OFFSET];
    let curr_pc = curr[0 + MEM_A_TRACE_OFFSET];

    let curr_f_dst_fp = curr[0 + POS_FLAGS];
    let curr_off_dst = bias(curr[0 + OFF_X_TRACE_OFFSET]);
    let curr_dst_addr = curr[1 + MEM_A_TRACE_OFFSET];
    let curr_f_op0_fp = curr[1 + POS_FLAGS];
    let curr_off_op0 = bias(curr[1 + OFF_X_TRACE_OFFSET]);
    let curr_op0_addr = curr[2 + MEM_A_TRACE_OFFSET];
    let curr_f_op1_val = curr[2 + POS_FLAGS];
    let curr_f_op1_ap = curr[4 + POS_FLAGS];
    let curr_f_op1_fp = curr[3 + POS_FLAGS];
    let curr_op0 = curr[2 + MEM_V_TRACE_OFFSET];
    let curr_off_op1 = bias(curr[2 + OFF_X_TRACE_OFFSET]);
    let curr_op1_addr = curr[3 + MEM_A_TRACE_OFFSET];

    assert t_evaluations1[DST_ADDR] = curr_f_dst_fp * curr_fp + (1 - curr_f_dst_fp) * curr_ap + curr_off_dst - curr_dst_addr;
    assert t_evaluations1[OP0_ADDR] = curr_f_op0_fp * curr_fp + (1 - curr_f_op0_fp) * curr_ap + curr_off_op0 - curr_op0_addr;
    assert t_evaluations1[OP1_ADDR] = curr_f_op1_val * curr_pc + 
        curr_f_op1_ap * curr_ap + 
        curr_f_op1_fp * curr_fp + 
        (1 - curr_f_op1_val - curr_f_op1_ap - curr_f_op1_fp) * curr_op0 + 
        curr_off_op1 - curr_op1_addr;
    return ();
}

func evaluate_register_constraints(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*
) {
    let curr = ood_main_trace_frame.current;
    let next = ood_main_trace_frame.next;

    // ap constraints
    let curr_ap = curr[0 + MEM_P_TRACE_OFFSET];
    let curr_f_ap_add = curr[10 + POS_FLAGS];
    let curr_res = curr[0 + RES_TRACE_OFFSET];
    let curr_f_ap_one = curr[11 + POS_FLAGS];
    let curr_f_opc_call = curr[12 + POS_FLAGS];
    let next_ap = next[0 + MEM_P_TRACE_OFFSET];
    let next_ap_constraint = curr_ap + curr_f_ap_add * curr_res + curr_f_ap_one + curr_f_opc_call * 2 - next_ap;
    assert t_evaluations1[NEXT_AP] = next_ap_constraint;

    // fp constraints
    let curr_f_opc_ret = curr[13 + POS_FLAGS];
    let curr_dst = curr[1 + MEM_V_TRACE_OFFSET];
    let curr_fp = curr[1 + MEM_P_TRACE_OFFSET];
    let next_fp = next[1 + MEM_P_TRACE_OFFSET];
    let next_fp_constraint = curr_f_opc_ret * curr_dst + curr_f_opc_call * (curr_ap + 2) + (1 - curr_f_opc_ret - curr_f_opc_call) * curr_fp - next_fp;
    assert t_evaluations1[NEXT_FP] = next_fp_constraint;

    // pc constraint 1
    let curr_t1 = curr[1 + DERIVED_TRACE_OFFSET];
    let curr_f_pc_jnz = curr[9 + POS_FLAGS];
    let curr_inst_size = curr[2 + POS_FLAGS] + 1;
    let next_pc = next[0 + MEM_A_TRACE_OFFSET];
    let curr_pc = curr[0 + MEM_A_TRACE_OFFSET];
    let next_pc_constraint1 = (curr_t1 - curr_f_pc_jnz) * (next_pc - (curr_pc + curr_inst_size));
    assert t_evaluations1[NEXT_PC_1] = next_pc_constraint1;

    // pc constraint 2
    let curr_t0 = curr[0 + DERIVED_TRACE_OFFSET];
    let curr_op1 = curr[3 + MEM_V_TRACE_OFFSET];
    let curr_f_pc_abs = curr[7 + POS_FLAGS];
    let curr_f_pc_rel = curr[8 + POS_FLAGS];
    let next_pc_constraint2 = curr_t0 * (next_pc - (curr_pc + curr_op1)) + 
                                  (1 - curr_f_pc_jnz) * next_pc - 
                                  ((1 - curr_f_pc_abs - curr_f_pc_rel - curr_f_pc_jnz) * (curr_pc + curr_inst_size) + 
                                  curr_f_pc_abs * curr_res + 
                                  curr_f_pc_rel * (curr_pc + curr_res));
    assert t_evaluations1[NEXT_PC_2] = next_pc_constraint2;

    // T0 and T1
    assert t_evaluations1[T0] = curr_f_pc_jnz * curr_dst - curr_t0;
    assert t_evaluations1[T1] = curr_t0 * curr_res - curr_t1;

    return ();
}

func evaluate_opcode_constraints(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*
) {
    let curr = ood_main_trace_frame.current;

    let curr_mul = curr[2 + DERIVED_TRACE_OFFSET];
    let curr_op0 = curr[2 + MEM_V_TRACE_OFFSET];
    let curr_op1 = curr[3 + MEM_V_TRACE_OFFSET];
    let curr_f_res_add = curr[5 + POS_FLAGS];
    let curr_f_res_mul = curr[6 + POS_FLAGS];
    let curr_f_pc_jnz = curr[9 + POS_FLAGS];
    let curr_res = curr[0 + RES_TRACE_OFFSET];
    let curr_f_opc_call = curr[12 + POS_FLAGS];
    let curr_dst = curr[1 + MEM_V_TRACE_OFFSET];
    let curr_fp = curr[1 + MEM_P_TRACE_OFFSET];
    let curr_pc = curr[0 + MEM_A_TRACE_OFFSET];
    let curr_inst_size = curr[2 + POS_FLAGS] + 1;
    let curr_f_opc_aeq = curr[14 + POS_FLAGS];

    assert t_evaluations1[MUL_1] = curr_mul - (curr_op0 * curr_op1);
    assert t_evaluations1[MUL_2] = curr_f_res_add * (curr_op0 + curr_op1) + 
        curr_f_res_mul * curr_mul + 
        (1 - curr_f_res_add - curr_f_res_mul - curr_f_pc_jnz) * curr_op1 - 
        (1 - curr_f_pc_jnz) * curr_res;
    assert t_evaluations1[CALL_1] = curr_f_opc_call * (curr_dst - curr_fp);
    assert t_evaluations1[CALL_2] = curr_f_opc_call * (curr_op0 - (curr_pc + curr_inst_size));
    assert t_evaluations1[ASSERT_EQ] = curr_f_opc_aeq * (curr_dst - curr_res);

    return ();
}

func enforce_selector(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*,
    result: felt*
) {
    memcpy(result, t_evaluations1, 16);
    let curr = ood_main_trace_frame.current;
    
    // Unrolled the for loop from 16 to 30:
    let factor = curr[0 + SELECTOR_TRACE_OFFSET];
    assert result[16] = t_evaluations1[16] * factor;
    assert result[17] = t_evaluations1[17] * factor;
    assert result[18] = t_evaluations1[18] * factor;
    assert result[19] = t_evaluations1[19] * factor;

    assert result[20] = t_evaluations1[20] * factor;
    assert result[21] = t_evaluations1[21] * factor;
    assert result[22] = t_evaluations1[22] * factor;
    assert result[23] = t_evaluations1[23] * factor;

    assert result[24] = t_evaluations1[24] * factor;
    assert result[25] = t_evaluations1[25] * factor;
    assert result[26] = t_evaluations1[26] * factor;
    assert result[27] = t_evaluations1[27] * factor;

    assert result[28] = t_evaluations1[28] * factor;
    assert result[29] = t_evaluations1[29] * factor;
    assert result[30] = t_evaluations1[30] * factor;

    memcpy(result, t_evaluations1, 17);

    return ();
}

func evaluate_aux_transition(
    ood_main_trace_frame: EvaluationFrame, 
    ood_aux_trace_frame: EvaluationFrame, 
    aux_trace_rand_elements: felt*,
    t_evaluations2: felt*,
) {
    evaluate_memory_constraints(ood_main_trace_frame, ood_aux_trace_frame, aux_trace_rand_elements, t_evaluations2);
    evaluate_range_check_constraints(ood_main_trace_frame, ood_aux_trace_frame, aux_trace_rand_elements, t_evaluations2);
    return ();
}

func get_virtual(frame: EvaluationFrame, index, offset, width){
    alloc_locals;
    local is_index_ge_width;

    // Width always equals 3 or 4
    if(width == 4){
        assert is_index_ge_width = index * (index-1) * (index-2) * (index-3);
    } else {
        assert is_index_ge_width = index * (index-1) * (index-2);
    }

    if( is_index_ge_width != 0 ){
        // 0 <= index < width
        return frame.current[offset + index];
    } else {
        // width <= index < width * 2
        return frame.next[offset + index - width];
    }
}

func evaluate_memory_constraints(
    main_frame: EvaluationFrame, 
    aux_frame: EvaluationFrame, 
    aux_rand_elements: felt*,
    t_evaluations2: felt*,
){
    let curr = main_frame.current;

    let random_elements = aux_rand_elements;
    let z = random_elements[0];
    let alpha = random_elements[1];

    /// 1. Continuity constraint

    // Unroll the for loop for i in [0..4] and n in [0..4]
    let aux_a_m_prime_0 = get_virtual(aux_frame, 0, A_M_PRIME_OFFSET, A_M_PRIME_WIDTH);
    let aux_a_m_prime_1 = get_virtual(aux_frame, 1, A_M_PRIME_OFFSET, A_M_PRIME_WIDTH);
    let aux_a_m_prime_2 = get_virtual(aux_frame, 2, A_M_PRIME_OFFSET, A_M_PRIME_WIDTH);
    let aux_a_m_prime_3 = get_virtual(aux_frame, 3, A_M_PRIME_OFFSET, A_M_PRIME_WIDTH);
    let aux_a_m_prime_4 = get_virtual(aux_frame, 4, A_M_PRIME_OFFSET, A_M_PRIME_WIDTH);
    assert t_evaluations2[0] = (aux_a_m_prime_1 - aux_a_m_prime_0) * (aux_a_m_prime_1 - aux_a_m_prime_0 - 1);
    assert t_evaluations2[1] = (aux_a_m_prime_2 - aux_a_m_prime_1) * (aux_a_m_prime_2 - aux_a_m_prime_1 - 1);
    assert t_evaluations2[2] = (aux_a_m_prime_3 - aux_a_m_prime_2) * (aux_a_m_prime_3 - aux_a_m_prime_2 - 1);
    assert t_evaluations2[3] = (aux_a_m_prime_4 - aux_a_m_prime_3) * (aux_a_m_prime_4 - aux_a_m_prime_3 - 1);


    /// 2. Single-valued constraint

    // Unroll the for loop for i in [0..4] and n in [4..8]
    let aux_v_m_prime_0 = get_virtual(aux_frame, 0, V_M_PRIME_OFFSET, V_M_PRIME_WIDTH);
    let aux_v_m_prime_1 = get_virtual(aux_frame, 1, V_M_PRIME_OFFSET, V_M_PRIME_WIDTH);
    let aux_v_m_prime_2 = get_virtual(aux_frame, 2, V_M_PRIME_OFFSET, V_M_PRIME_WIDTH);
    let aux_v_m_prime_3 = get_virtual(aux_frame, 3, V_M_PRIME_OFFSET, V_M_PRIME_WIDTH);
    let aux_v_m_prime_4 = get_virtual(aux_frame, 4, V_M_PRIME_OFFSET, V_M_PRIME_WIDTH);
    assert t_evaluations2[4] = (aux_v_m_prime_1 - aux_v_m_prime_0) * (aux_a_m_prime_1 - aux_a_m_prime_0 - 1);
    assert t_evaluations2[5] = (aux_v_m_prime_2 - aux_v_m_prime_1) * (aux_a_m_prime_2 - aux_a_m_prime_1 - 1);
    assert t_evaluations2[6] = (aux_v_m_prime_3 - aux_v_m_prime_2) * (aux_a_m_prime_3 - aux_a_m_prime_2 - 1);
    assert t_evaluations2[7] = (aux_v_m_prime_4 - aux_v_m_prime_3) * (aux_a_m_prime_4 - aux_a_m_prime_3 - 1);


    /// 3. Cumulative product step

    // Unroll the for loop for i in [0..4] and n in [8..12]
    let aux_p_m_0 = get_virtual(aux_frame, 0, P_M_OFFSET, P_M_WIDTH);
    let aux_p_m_1 = get_virtual(aux_frame, 1, P_M_OFFSET, P_M_WIDTH);
    let aux_p_m_2 = get_virtual(aux_frame, 2, P_M_OFFSET, P_M_WIDTH);
    let aux_p_m_3 = get_virtual(aux_frame, 3, P_M_OFFSET, P_M_WIDTH);
    let aux_p_m_4 = get_virtual(aux_frame, 4, P_M_OFFSET, P_M_WIDTH);

    let a_m_1 = get_virtual(main_frame, 1, MEM_A_TRACE_OFFSET, MEM_A_TRACE_WIDTH);
    let a_m_2 = get_virtual(main_frame, 2, MEM_A_TRACE_OFFSET, MEM_A_TRACE_WIDTH);
    let a_m_3 = get_virtual(main_frame, 3, MEM_A_TRACE_OFFSET, MEM_A_TRACE_WIDTH);
    let a_m_4 = get_virtual(main_frame, 4, MEM_A_TRACE_OFFSET, MEM_A_TRACE_WIDTH);

    let v_m_1 = get_virtual(main_frame, 1, MEM_V_TRACE_OFFSET, MEM_V_TRACE_WIDTH);
    let v_m_2 = get_virtual(main_frame, 2, MEM_V_TRACE_OFFSET, MEM_V_TRACE_WIDTH);
    let v_m_3 = get_virtual(main_frame, 3, MEM_V_TRACE_OFFSET, MEM_V_TRACE_WIDTH);
    let v_m_4 = get_virtual(main_frame, 4, MEM_V_TRACE_OFFSET, MEM_V_TRACE_WIDTH);

    assert t_evaluations2[8]  = (z - (aux_a_m_prime_1 + alpha * aux_v_m_prime_1)) * aux_p_m_1 - (z - (a_m_1 + alpha * v_m_1)) * aux_p_m_0;
    assert t_evaluations2[9]  = (z - (aux_a_m_prime_2 + alpha * aux_v_m_prime_2)) * aux_p_m_2 - (z - (a_m_2 + alpha * v_m_2)) * aux_p_m_1;
    assert t_evaluations2[10] = (z - (aux_a_m_prime_3 + alpha * aux_v_m_prime_3)) * aux_p_m_3 - (z - (a_m_3 + alpha * v_m_3)) * aux_p_m_2;
    assert t_evaluations2[11] = (z - (aux_a_m_prime_4 + alpha * aux_v_m_prime_4)) * aux_p_m_4 - (z - (a_m_4 + alpha * v_m_4)) * aux_p_m_3;

    return ();
}

func evaluate_range_check_constraints(
    main_frame: EvaluationFrame, 
    aux_frame: EvaluationFrame, 
    aux_rand_elements: felt*,
    t_evaluations2: felt*,
){
    let curr = main_frame.current;

    let random_elements = aux_rand_elements;
    let z = random_elements[0];

    /// 1. Continuity constraint
    // Unroll the for loop for i in [0..3] and n in [12..15]
    let aux_a_rc_prime_0 = get_virtual(aux_frame, 0, A_RC_PRIME_OFFSET, A_RC_PRIME_WIDTH);
    let aux_a_rc_prime_1 = get_virtual(aux_frame, 1, A_RC_PRIME_OFFSET, A_RC_PRIME_WIDTH);
    let aux_a_rc_prime_2 = get_virtual(aux_frame, 2, A_RC_PRIME_OFFSET, A_RC_PRIME_WIDTH);
    let aux_a_rc_prime_3 = get_virtual(aux_frame, 3, A_RC_PRIME_OFFSET, A_RC_PRIME_WIDTH);
    assert t_evaluations2[12] = (aux_a_rc_prime_1 - aux_a_rc_prime_0) * (aux_a_rc_prime_1 - aux_a_rc_prime_0 - 1);
    assert t_evaluations2[13] = (aux_a_rc_prime_2 - aux_a_rc_prime_1) * (aux_a_rc_prime_2 - aux_a_rc_prime_1 - 1);
    assert t_evaluations2[14] = (aux_a_rc_prime_3 - aux_a_rc_prime_2) * (aux_a_rc_prime_3 - aux_a_rc_prime_2 - 1);
    

    /// 2. Cumulative product step
    // Unroll the for loop for i in [0..3] and n in [15..18]
    let aux_p_rc_0 = get_virtual(aux_frame, 0, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);
    let aux_p_rc_1 = get_virtual(aux_frame, 1, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);
    let aux_p_rc_2 = get_virtual(aux_frame, 2, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);
    let aux_p_rc_3 = get_virtual(aux_frame, 3, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);

    let curr_a_rc_1 = get_virtual(main_frame, 1, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);
    let curr_a_rc_2 = get_virtual(main_frame, 2, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);
    let curr_a_rc_3 = get_virtual(main_frame, 3, OFF_X_TRACE_OFFSET, OFF_X_TRACE_WIDTH);

    assert t_evaluations2[15] = (z - aux_a_rc_prime_1) * aux_p_rc_1 - (z - curr_a_rc_1) * aux_p_rc_0;
    assert t_evaluations2[16] = (z - aux_a_rc_prime_2) * aux_p_rc_2 - (z - curr_a_rc_2) * aux_p_rc_1;
    assert t_evaluations2[17] = (z - aux_a_rc_prime_3) * aux_p_rc_3 - (z - curr_a_rc_3) * aux_p_rc_2;
    
    return ();
}
