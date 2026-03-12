# Minimal toolchain for aarch64 cross compilation using gcc cross toolchain
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Путь к rootfs Armbian (ОБЯЗАТЕЛЬНО укажи свой путь!)
set(CMAKE_SYSROOT "/home/me/armbian-rootfs")

# Кросс-компиляторы
set(CMAKE_C_COMPILER   /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# Настройка sysroot для компилятора и линковщика
set(CMAKE_C_FLAGS          "--sysroot=${CMAKE_SYSROOT}")
set(CMAKE_CXX_FLAGS        "--sysroot=${CMAKE_SYSROOT}")
set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT}")

# Пути поиска библиотек и заголовков — только внутри rootfs
set(CMAKE_FIND_ROOT_PATH
    ${CMAKE_SYSROOT}
)

# Программы ищем в системе WSL
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Библиотеки и заголовки — только в rootfs
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
