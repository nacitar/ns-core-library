#include <feature_check/any_type_with_bit_size.hxx>
static_assert(
    any_type_with_bit_size<64>(StandardIntegralTypes{}),
    "None of the integral types is exactly 64 bits."
);
