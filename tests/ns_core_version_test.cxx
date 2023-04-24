#include <cstdio>

#include "ns/core/version.h"

int main() {
  printf("Project: %s\nVersion: %06X\nBranch: %s\nCommit Hash: %s\n",
      ns::core::kProjectName, ns::core::kVersion,
      ns::core::kBranchName, ns::core::kCommitHash);
  return 0;
}
