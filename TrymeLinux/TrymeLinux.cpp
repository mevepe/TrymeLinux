#include <gpiod.hpp>
#include <iostream>
#include <thread>
#include <chrono>

int main()
{
	std::cout << "Hello CMake.\n";

	const char* chipname = "/dev/gpiochip0";
	int line_num = 15; // PA15

	try {
		gpiod::chip chip(chipname);
		gpiod::line line = chip.get_line(line_num);

		line.request({ "gpio-example", gpiod::line_request::DIRECTION_OUTPUT, 0 }, 0);

		for (int i = 0; i < 10; i++) {
			line.set_value(1);
			std::this_thread::sleep_for(std::chrono::milliseconds(500));
			line.set_value(0);
			std::this_thread::sleep_for(std::chrono::milliseconds(500));
		}

	}
	catch (const std::exception& e) {
		std::cerr << "Ошибка: " << e.what() << std::endl;
	}

	return 0;
}
