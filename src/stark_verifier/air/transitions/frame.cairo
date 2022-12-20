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
//// MAIN TRACE LAYOUT
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
//
const FLAG_TRACE_OFFSET = 0;
const RES_TRACE_OFFSET = 16;
const MEM_P_TRACE_OFFSET = 17;
const MEM_A_TRACE_OFFSET = 19;
const MEM_V_TRACE_OFFSET = 23;
const OFF_X_TRACE_OFFSET = 27;
const DERIVED_TRACE_OFFSET = 30;
const SELECTOR_TRACE_OFFSET = 33;
const POS_FLAGS = 48;


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
    evaluate_register_constraints(ood_main_trace_frame, t_evaluations1);
    return ();
}


func evaluate_register_constraints(
    ood_main_trace_frame: EvaluationFrame, 
    t_evaluations1: felt*
) {
    // ap constraints
    tempvar curr_ap = ood_main_trace_frame.current[0 + MEM_P_TRACE_OFFSET];
    tempvar curr_f_ap_add = ood_main_trace_frame.current[10 + POS_FLAGS];
    tempvar curr_res = ood_main_trace_frame.current[0 + RES_TRACE_OFFSET];
    tempvar curr_f_ap_one = ood_main_trace_frame.current[11 + POS_FLAGS];
    tempvar curr_f_opc_call = ood_main_trace_frame.current[12 + POS_FLAGS];
    tempvar next_ap = ood_main_trace_frame.next[0 + MEM_P_TRACE_OFFSET];
    tempvar next_ap_constraint = curr_ap + curr_f_ap_add * curr_res + curr_f_ap_one + curr_f_opc_call * 2 - next_ap;
    assert t_evaluations1[NEXT_AP] = next_ap_constraint;

    // fp constraints
    tempvar curr_f_opc_ret = ood_main_trace_frame.current[13 + POS_FLAGS];
    tempvar curr_dst = ood_main_trace_frame.current[1 + MEM_V_TRACE_OFFSET];
    tempvar curr_fp = ood_main_trace_frame.current[1 + MEM_P_TRACE_OFFSET];
    tempvar next_fp = ood_main_trace_frame.next[1 + MEM_P_TRACE_OFFSET];
    tempvar next_fp_constraint = curr_f_opc_ret * curr_dst + curr_f_opc_call * (curr_ap + 2) + (1 - curr_f_opc_ret - curr_f_opc_call) * curr_fp - next_fp;
    assert t_evaluations1[NEXT_FP] = next_fp_constraint;

    // pc constraint 1
    tempvar curr_t1 = ood_main_trace_frame.current[1 + DERIVED_TRACE_OFFSET];
    tempvar curr_f_pc_jnz = ood_main_trace_frame.current[9 + POS_FLAGS];
    tempvar curr_inst_size = ood_main_trace_frame.current[2 + POS_FLAGS] + 1;
    tempvar next_pc = ood_main_trace_frame.next[0 + MEM_A_TRACE_OFFSET];
    tempvar curr_pc = ood_main_trace_frame.current[0 + MEM_A_TRACE_OFFSET];
    tempvar next_pc_constraint1 = (curr_t1 - curr_f_pc_jnz) * (next_pc - (curr_pc + curr_inst_size));
    assert t_evaluations1[NEXT_PC_1] = next_pc_constraint1;

    // pc constraint 2
    tempvar curr_t0 = ood_main_trace_frame.current[0 + DERIVED_TRACE_OFFSET];
    tempvar curr_op1 = ood_main_trace_frame.current[3 + MEM_V_TRACE_OFFSET];
    tempvar curr_f_pc_abs = ood_main_trace_frame.current[7 + POS_FLAGS];
    tempvar curr_f_pc_rel = ood_main_trace_frame.current[8 + POS_FLAGS];
    tempvar next_pc_constraint2 = curr_t0 * (next_pc - (curr_pc + curr_op1)) + 
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



func evaluate_aux_transition(
    ood_main_trace_frame: EvaluationFrame, 
    ood_aux_trace_frame: EvaluationFrame, 
    aux_trace_rand_elements: felt*,
    t_evaluations2: felt*,
) {
    // TODO
    return ();
}

func combine_evaluations(
    t_evaluations1: felt*,
    t_evaluations2: felt*,
    z: felt,
) {
    // TODO
    return ();
}
