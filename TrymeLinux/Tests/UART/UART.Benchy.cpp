#include "UART.Benchy.h"

#include <iostream>
#include <string>
#include <libserial/SerialPort.h>
#include <libserial/SerialStream.h>
#include <gpiod.hpp>


namespace tests
{
	void uart_benchy_start()
	{
		using namespace LibSerial;

		const std::string port_name = "/dev/ttyS7";
		SerialPort serial;

		try
		{
			// Открываем UART
			serial.Open(port_name, std::ios_base::in | std::ios_base::out);

			// Настройка порта
			serial.SetBaudRate(BaudRate::BAUD_115200);
			serial.SetCharacterSize(CharacterSize::CHAR_SIZE_8);
			serial.SetParity(Parity::PARITY_NONE);
			serial.SetStopBits(StopBits::STOP_BITS_1);
			serial.SetFlowControl(FlowControl::FLOW_CONTROL_NONE);

			std::cout << "UART открыт: " << port_name << std::endl;

			while (true)
			{
				// Проверяем, есть ли данные
				if (serial.IsDataAvailable())
				{
					std::string received;
					serial.ReadLine(received, '\n');  // читаем строку до \n

					std::cout << "Получено: " << received << std::endl;

					// Формируем ответ
					std::string reply = "Ответ: " + received + "\n";
					serial.Write(reply);

					std::cout << "Отправлено: " << reply << std::endl;
				}

				// Небольшая задержка, чтобы не грузить CPU
				usleep(1000);
			}
		}
		catch (const OpenFailed&)
		{
			std::cerr << "Ошибка: не удалось открыть UART " << port_name << std::endl;
			return;
		}
		catch (const std::exception& e)
		{
			std::cerr << "Ошибка LibSerial: " << e.what() << std::endl;
			return;
		}
	}
}