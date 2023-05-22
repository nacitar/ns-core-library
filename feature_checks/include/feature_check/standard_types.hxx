template <typename... Ts>
struct TypeList {};

using StandardIntegralTypes = TypeList<char, short, int, long, long long>;
