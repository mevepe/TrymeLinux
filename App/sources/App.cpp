#include <iostream>
#include <sched.h>
#include <pthread.h>

#include "Tests/GPIO/GPIO.Benchy.h"
#include "Tests/UART/UART.Benchy.h"

int main()
{
    auto target_cpu = 3;
    auto priority = 95;

    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(target_cpu, &cpuset);

    pthread_t thread = pthread_self();
    auto affinityError = pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset);

    if (affinityError != 0)
    {
        std::cerr << "Ошибка установки CPU: " << affinityError << "\n";

        return false;
    }

    sched_param sch_params = { priority };

    auto schedError = pthread_setschedparam(pthread_self(), SCHED_FIFO, &sch_params);

    if (schedError != 0)
    {
        std::cerr << "Ошибка установки приоритета: " << affinityError << "\n";

        return false;
    }

	tests::gpio_benchy_start();
	//tests::uart_benchy_start();

	return 0;
}
