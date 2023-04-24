#include <cstdio>

#include "ns/core/version.hpp"
#include "ns/core/vcs/metadata.hpp"

int main() {
  printf("Project: %s\nVersion: %06X\nBranch: %s\nCommit Hash: %s\n",
      ns::core::kProjectName, ns::core::kVersion,
      ns::core::vcs::kBranchName, ns::core::vcs::kCommitHash);
  return 0;
}
