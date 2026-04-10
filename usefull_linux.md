## Сборка и развертывание нового ядра
### Копирование файлов ядра
```bash
scp output/debs/*.deb mevepe@192.168.137.100:/home/mevepe/Desktop/armbian-core
```

### Установка ядра
Первый раз
```bash
sudo apt-get update
sudo apt-get install pahole -y
```
Постоянно
```bash
sudo dpkg -i linux-image-*.deb linux-dtb-*.deb
sudo dpkg -i linux-headers-*.deb
sudo dpkg -i linux-u-boot-*.deb
```

### Обновление загрузчика и заморозка обновления ядра
```bash
sudo update-initramfs -u
sudo armbian-config
dpkg --get-selections | grep hold
```

### Перезагрузка и проверка версии нового ядра
```bash
sudo reboot
uname -a
sudo apt-get update
```

## Network
### Редактирование параметров соединений
```bash
sudo nmtui # приложение с интерфейсом
sudo nmcli
```

### Статус соединений
```bash
ip route show | grep default
```

### Список соединений
```bash
nmcli con show
```

### Проверка какое соединение главное
```bash
ip route get 8.8.8.8
```

### Назначить приоритет соединению и перезапустить его
```bash
sudo nmcli con mod "wired-connection-1" ipv4.route-metric 201
sudo nmcli con down "wired-connection-1" && sudo nmcli con up "wired-connection-1"
sudo nmcli con mod "netplan-wifi-mevepe-5hhz" ipv4.route-metric 101
sudo nmcli con down "netplan-wifi-mevepe-5hhz" && sudo nmcli con up "netplan-wifi-mevepe-5hhz"
```

## Apt Manager
### Добавить зеркало для работы apt-get
```bash
sudo nano /etc/apt/sources.list.d/armbian.list
```

```text
deb [signed-by=/usr/share/keyrings/armbian.gpg] https://mirror.yandex.ru/mirrors/armbian/apt noble main noble-utils noble-desktop
```

## SSH
### Создание authorized_keys
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
sudo nano ~/.ssh/authorized_keys
```

```text
ssh-rsa <КЛЮЧ SSH> mevep@DESKTOP-6HBR84I
```

### Редактирование настроек для включения входа по ключу
```bash
sudo nano /etc/ssh/sshd_config
sudo systemctl restart ssh
```

```text
PubkeyAuthentication yes
PasswordAuthentication yes
PermitRootLogin prohibit-password
```

## Корректировка системных разделов
### Установка необходимых пакетов
```bash
sudo apt install gdisk
sudo apt install nand-sata-install
```

## Настройка системы для удаленной отладки
### Установка необходимых пакетов
```bash
sudo apt install -y openssh-server build-essential make zip libc6-dev linux-libc-dev gdb gdbserver rsync
```

### Прописываем ssh ключ
```bash
ssh-copy-id -i wsl-remote-debug.pub mevepe@192.168.0.100
ssh -i wsl-remote-debug mevepe@192.168.0.101 # используем ключ
```

## Настройка системы для realtime
### Отключение интерфейса
```bash
sudo systemctl set-default multi-user.target
sudo reboot
```

### Просмотр доступных overlays
```bash
ls /boot/dtb/rockchip/overlay/ | grep sata*
ls /boot/dtb/rockchip/overlay/ | grep uart*
ls /boot/dtb/rockchip/overlay/ | grep can*
```

### Выбор overlays
```bash
sudo dtc -I dtb -O dts -o /tmp/rk3566.dts /boot/dtb/rockchip/rk3566-orangepi-3b-v2.1.dtb
grep -R "uart" /tmp/rk3566.dts
ls /boot/dtb/rockchip/overlay/ | grep uart*

sudo nano /boot/armbianEnv.txt
sudo reboot
```

### Прописываем пользовательские исполняемые файлы
```bash
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local.conf
sudo cat /etc/ld.so.conf.d/local.conf
sudo ldconfig
ldconfig -p | grep -i libserial
```

### Скрипт для настройки системы после запуска
```bash
sudo nano /usr/local/bin/rt-tune.sh
sudo chmod +x /usr/local/bin/rt-tune.sh
sudo nano /etc/rc.local
sudo reboot
journalctl -b | grep rc.local
```

```text
sleep 5
/usr/local/bin/rt-tune.sh
```

```bash
#!/bin/bash

IRQ_CPUS="0-5"
RT_CPUS="6-7"

echo "Moving IRQs to CPU $IRQ_CPUS"

for i in /proc/irq/*/smp_affinity_list; do
    echo $IRQ_CPUS > $i 2>/dev/null
done

echo "Moving kernel threads away from RT CPU"

for pid in $(ps -eLo pid,comm | grep "\[" | awk '{print $1}'); do
    taskset -pc $IRQ_CPUS $pid >/dev/null 2>&1
done

echo "Setting CPU governor to performance"

for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > $g 2>/dev/null
done

echo "System tuned for realtime use"
echo "IRQ CPUs: $IRQ_CPUS"
echo "RT CPUs: $RT_CPUS"
```

### Выбор приоритетов для работы ядер
```bash
sudo nano /boot/armbianEnv.txt
```

```txt
extraargs=cma=256M isolcpus=5,6,7 nohz_full=5,6,7 rcu_nocbs=5,6,7
```

### Разрешаем использовать ядра на 100%
```bash
sudo nano /etc/sysctl.conf
```

```text
kernel.sched_rt_runtime_us=-1
```

### Разрешаем пользователям создавать RT задачи
```bash
sudo nano /etc/security/limits.conf
```

```text
root             soft    rtprio          99
root             hard    rtprio          99
root             soft    memlock         unlimited
root             hard    memlock         unlimited

mevepe           soft    rtprio          99
mevepe           hard    rtprio          99
mevepe           soft    memlock         unlimited
mevepe           hard    memlock         unlimited
```

### Библиотека для работы с Serial
```bash
sudo apt install -y g++ git autogen autoconf build-essential cmake graphviz libboost-dev libboost-test-dev libgtest-dev libtool python3-sip-dev doxygen python3-sphinx pkg-config python3-sphinx-rtd-theme
git clone https://github.com/crayzeewulf/libserial.git
cd libserial
mkdir build && cd build
cd ..
ls
./compile.sh
cd build
sudo make install
```

### Включаем UART
```bash
sudo nano /boot/armbianEnv.txt # или через armbian-config
sudo reboot
sudo dmesg | grep ttyS
```

```txt
overlays=uart4-m2 uart6-m1
```

### Настройка для работы с gpiod
```bash
sudo apt-get install gpiod libgpiod-dev
sudo groupadd gpio
sudo usermod -aG gpio $USER
getent group gpio
sudo nano /etc/udev/rules.d/99-gpio.rules
sudo gpioinfo
```

```txt
SUBSYSTEM=="gpio", KERNEL=="gpiochip*", MODE="0660", GROUP="gpio"
```

### Сопоставление line и GPIO со схемы для rockchip
```txt
line = GPIOX_YZ = Y * 8 + Z (X = chip index, Y = ABCD = 0123, Z = 0-7)
```

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
ls -l /dev/gpiochip0
```