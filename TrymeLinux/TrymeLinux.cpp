#include <gpiod.hpp>
#include <iostream>
#include <thread>
#include <chrono>

int main()
{
	std::cout << "GPIO Benchy!\n";

	try
	{
		// line number formula: GPIOX_YZ = Y * 8 + Z (X = chip index, Y = ABCD = 0123, Z = 0-7)

		auto gpiochip0 = gpiod::chip("/dev/gpiochip0");
		auto gpiochip1 = gpiod::chip("/dev/gpiochip1");
		auto gpiochip2 = gpiod::chip("/dev/gpiochip2");
		auto gpiochip3 = gpiod::chip("/dev/gpiochip3");

		auto gpio0_D1 = gpiochip0.get_line(25);
		auto gpio0_D0 = gpiochip0.get_line(24);
		auto gpio3_С7 = gpiochip3.get_line(23);

		gpio0_D1.request({ "gpio0-D1", gpiod::line_request::DIRECTION_OUTPUT, 0 }, 0);
		gpio0_D0.request({ "gpio0-D0", gpiod::line_request::DIRECTION_OUTPUT, 0 }, 0);
		gpio3_С7.request({ "gpio3-C7", gpiod::line_request::DIRECTION_OUTPUT, 0 }, 0);

		auto target_delta_time = 1e-3;
		auto start_time = std::chrono::high_resolution_clock::now();
		auto previous_time = start_time;
		auto value = 0;

		while (true)
		{
			gpio0_D1.set_value(value);
			gpio0_D0.set_value(value);
			gpio3_С7.set_value(value);

			while (true)
			{
				auto current_time = std::chrono::high_resolution_clock::now();
				auto delta_time_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(current_time - previous_time).count();
				auto delta_time = delta_time_ns / 1e+9;

				if (delta_time >= target_delta_time / 2.0)
				{
					previous_time = current_time;
					value = value == 0 ? 1 : 0;

					break;
				}
			}
		}
	}
	catch (const std::exception& e)
	{
		std::cerr << "Ошибка: " << e.what() << std::endl;
	}

	return 0;
}
