#include <cstdio>

#include "ns/core/version.hpp"
#include "ns/core/vcs/metadata.hpp"

int main() {
  printf("Project: %s\n", ns::core::kProjectName);
  printf("Version: %06X\n", ns::core::kVersion);
  printf("Branch: %s\n", ns::core::vcs::kBranchName);
  printf("Commit Hash: %s\n", ns::core::vcs::kCommitHash);
  printf("Local Changes: %d\n", ns::core::vcs::kHasLocalChanges);
  return 0;
}
