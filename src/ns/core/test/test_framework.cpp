#include <ns/core/test/test_framework.hpp>
#include <stdio.h>

Test* test_list_head = nullptr;

TestRegistrar::TestRegistrar(Test* test) {
    test->next = test_list_head;
    test_list_head = test;
}

int runTests() {
    int failedTests = 0;
    Test* current = test_list_head;

    while (current) {
        // Replace std::cout with a printf-like function, if available on your platform.
        // printf("Running %s ... ", current->name);

        if (current->func() != 0) {
            failedTests++;
        }

        current = current->next;
    }
    printf("WEE %d\n", failedTests);

    return failedTests;
}
