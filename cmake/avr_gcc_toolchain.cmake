# Set the system name to "Generic" for cross-compiling.
set(CMAKE_SYSTEM_NAME Generic)

# Set the toolchain prefix for AVR.
set(AVR_TOOLCHAIN_PREFIX avr)

# Specify the cross-compiler.
find_program(CMAKE_C_COMPILER   NAMES ${AVR_TOOLCHAIN_PREFIX}-gcc)
find_program(CMAKE_CXX_COMPILER NAMES ${AVR_TOOLCHAIN_PREFIX}-g++)
find_program(CMAKE_OBJCOPY      NAMES ${AVR_TOOLCHAIN_PREFIX}-objcopy)
find_program(CMAKE_OBJDUMP      NAMES ${AVR_TOOLCHAIN_PREFIX}-objdump)
find_program(CMAKE_SIZE         NAMES ${AVR_TOOLCHAIN_PREFIX}-size)

# Set the necessary compiler and linker flags.
set(CMAKE_C_FLAGS "-mmcu=${MCU} -DF_CPU=${F_CPU}" CACHE STRING "")
set(CMAKE_CXX_FLAGS "-mmcu=${MCU} -DF_CPU=${F_CPU}" CACHE STRING "")
set(CMAKE_EXE_LINKER_FLAGS "-mmcu=${MCU}" CACHE STRING "")

# Set the executable output format.
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
