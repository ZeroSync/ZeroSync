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


const NUM_FLAGS = 16;

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

    evaluate_instr_constraints(ood_main_trace_frame, t_evaluations1);
    evaluate_operand_constraints(ood_main_trace_frame, t_evaluations1);
    evaluate_register_constraints(ood_main_trace_frame, t_evaluations1);
    // evaluate_opcode_constraints(ood_main_trace_frame, t_evaluations1);
    // enforce_selector(ood_main_trace_frame, t_evaluations1);

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
    // ap constraints
    let curr_ap = ood_main_trace_frame.current[0 + MEM_P_TRACE_OFFSET];
    let curr_f_ap_add = ood_main_trace_frame.current[10 + POS_FLAGS];
    let curr_res = ood_main_trace_frame.current[0 + RES_TRACE_OFFSET];
    let curr_f_ap_one = ood_main_trace_frame.current[11 + POS_FLAGS];
    let curr_f_opc_call = ood_main_trace_frame.current[12 + POS_FLAGS];
    let next_ap = ood_main_trace_frame.next[0 + MEM_P_TRACE_OFFSET];
    let next_ap_constraint = curr_ap + curr_f_ap_add * curr_res + curr_f_ap_one + curr_f_opc_call * 2 - next_ap;
    assert t_evaluations1[NEXT_AP] = next_ap_constraint;

    // fp constraints
    let curr_f_opc_ret = ood_main_trace_frame.current[13 + POS_FLAGS];
    let curr_dst = ood_main_trace_frame.current[1 + MEM_V_TRACE_OFFSET];
    let curr_fp = ood_main_trace_frame.current[1 + MEM_P_TRACE_OFFSET];
    let next_fp = ood_main_trace_frame.next[1 + MEM_P_TRACE_OFFSET];
    let next_fp_constraint = curr_f_opc_ret * curr_dst + curr_f_opc_call * (curr_ap + 2) + (1 - curr_f_opc_ret - curr_f_opc_call) * curr_fp - next_fp;
    assert t_evaluations1[NEXT_FP] = next_fp_constraint;

    // pc constraint 1
    let curr_t1 = ood_main_trace_frame.current[1 + DERIVED_TRACE_OFFSET];
    let curr_f_pc_jnz = ood_main_trace_frame.current[9 + POS_FLAGS];
    let curr_inst_size = ood_main_trace_frame.current[2 + POS_FLAGS] + 1;
    let next_pc = ood_main_trace_frame.next[0 + MEM_A_TRACE_OFFSET];
    let curr_pc = ood_main_trace_frame.current[0 + MEM_A_TRACE_OFFSET];
    let next_pc_constraint1 = (curr_t1 - curr_f_pc_jnz) * (next_pc - (curr_pc + curr_inst_size));
    assert t_evaluations1[NEXT_PC_1] = next_pc_constraint1;

    // pc constraint 2
    let curr_t0 = ood_main_trace_frame.current[0 + DERIVED_TRACE_OFFSET];
    let curr_op1 = ood_main_trace_frame.current[3 + MEM_V_TRACE_OFFSET];
    let curr_f_pc_abs = ood_main_trace_frame.current[7 + POS_FLAGS];
    let curr_f_pc_rel = ood_main_trace_frame.current[8 + POS_FLAGS];
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
