#include <feature_check/standard_types.hxx>

constexpr int BITS_IN_CHAR = []() {
    unsigned char value = static_cast<unsigned char>(~0U);
    int bits = 0;
    while (value) {
        value >>= 1;
        ++bits;
    }
    return bits;
}();

template <unsigned int number_of_bits, typename... Ts>
constexpr bool any_type_with_bit_size() {
    return (... || (sizeof(Ts) * BITS_IN_CHAR == number_of_bits));
}

template<unsigned int number_of_bits, typename... Ts>
constexpr bool any_type_with_bit_size(TypeList<Ts...>) {
    return any_type_with_bit_size<number_of_bits, Ts...>();
}
