#ifndef NS_CORE_TEST_TEST_FRAMEWORK_HPP
#define NS_CORE_TEST_TEST_FRAMEWORK_HPP
typedef int (*TestFunc)();

struct Test {
    const char* name;
    TestFunc func;
    Test* next;
};

extern Test* test_list_head;

int runTests();

class TestRegistrar {
public:
    TestRegistrar(Test* test);
};

#define TEST(test_name) \
    int test_name(); \
    Test _test_##test_name = {#test_name, test_name, nullptr}; \
    TestRegistrar _registrar_##test_name(&_test_##test_name); \
    int test_name()

#endif  // NS_CORE_TEST_TEST_FRAMEWORK_HPP
