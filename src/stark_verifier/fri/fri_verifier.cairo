from stark_verifier.air.air_instance import AirInstance
from stark_verifier.channel import Channel

struct FriVerifier {
}

func fri_verifier_new(air: AirInstance) -> FriVerifier {
    alloc_locals;
    let res = FriVerifier();
    return res;
}

func fri_verify{channel: Channel}(
    fri_verifier: FriVerifier, evaluations: felt*, positions: felt*
) {
    // TODO
    return ();
}
