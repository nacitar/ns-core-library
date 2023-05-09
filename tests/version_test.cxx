#include <stdio.h>

#include "ns/core/version.hpp"
#include "ns/core/vcs/metadata.hpp"

int main() {
  printf("Project: %s\n", ns::core::kProjectName);
  printf("Version: %02X%02X%02X\n",
          ns::core::kVersionMajor, ns::core::kVersionMinor, ns::core::kVersionPatch);
  printf("Branch: %s\n", ns::core::vcs::kBranchName);
  printf("Commit Hash: %s\n", ns::core::vcs::kCommitHash);
  printf("Local Changes: %d\n", ns::core::vcs::kHasLocalChanges);
  return 0;
}
