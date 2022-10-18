from stark_verifier.air.air_instance import (
    AirInstance,
)
from stark_verifier.channel import (
    Channel,
)

struct FriVerifier {
}

func fri_verifier_new(
    air: AirInstance,
) -> (res: FriVerifier) {
    alloc_locals;

    return (res=FriVerifier());
}

func fri_verify{channel: Channel}(
    fri_verifier: FriVerifier,
    evaluations: felt*,
    positions: felt*,
) -> () {
    // TODO
    return ();
}
