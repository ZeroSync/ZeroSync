from starkware.cairo.common.uint256 import Uint256

from starkware.cairo.common.cairo_secp.signature import get_point_from_x
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint
from starkware.cairo.common.cairo_secp.ec import EcPoint, ec_add, ec_mul
from starkware.cairo.common.cairo_secp.signature import (
    validate_signature_entry,
    get_generator_point,
    div_mod_n,
)

func get_ecpoint_from_pubkey{range_check_ptr}(x: Uint256, y: Uint256) -> EcPoint {
    if ((y.low - 2) * (y.low - 3) == 0) {
        let (x1: BigInt3) = uint256_to_bigint(x);
        let (point: EcPoint) = get_point_from_x(x1, y.low);
        return point;
    }
    let (x1: BigInt3) = uint256_to_bigint(x);
    let (y1: BigInt3) = uint256_to_bigint(y);
    let point = EcPoint(x1, y1);
    return point;
}

// Verifies a Secp256k1 ECDSA signature.
// Soundness assumptions:
// * public_key_pt is on the curve.
// * All the limbs of public_key_pt.x, public_key_pt.y, msg_hash are in the range [0, 3 * BASE).
func verify_ecdsa_secp256k1{range_check_ptr}(
    point_x: Uint256, point_y: Uint256, tx_hash: Uint256, sig_r: Uint256, sig_s: Uint256
) {
    alloc_locals;

    let pt: EcPoint = get_ecpoint_from_pubkey(point_x, point_y);
    let (r: BigInt3) = uint256_to_bigint(sig_r);
    let (s: BigInt3) = uint256_to_bigint(sig_s);
    let (z: BigInt3) = uint256_to_bigint(tx_hash);
    
    with_attr error_message("Signature out of range.") {
        validate_signature_entry(r);
        validate_signature_entry(s);
    }

    let (gen_pt: EcPoint) = get_generator_point();

    // Compute u1 and u2.
    let (u1: BigInt3) = div_mod_n(z, s);
    let (u2: BigInt3) = div_mod_n(r, s);

    // The following assert also implies that res is not the zero point.
    with_attr error_message("Invalid signature.") {
        let (gen_u1: EcPoint) = ec_mul(gen_pt, u1);
        let (pub_u2: EcPoint) = ec_mul(pt, u2);
        let (res) = ec_add(gen_u1, pub_u2);
        assert res.x = r;
    }

    return ();
}

// TODO: implement DER encoding for ECDSA signatures