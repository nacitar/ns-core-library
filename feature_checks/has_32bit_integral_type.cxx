#include <feature_check/any_type_with_bit_size.hxx>
static_assert(
    any_type_with_bit_size<32>(StandardIntegralTypes{}),
    "None of the integral types is exactly 32 bits."
);
