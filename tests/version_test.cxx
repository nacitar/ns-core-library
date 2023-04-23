#include <cstdio>

#include "ns/core/version.h"

int main() {
  printf("Version: %06X\n", ns::core::kVersion);
  return 0;
}
