@echo off

REM Скрипт для запуска всего проекта в Windows

echo 🚀 Запуск Codev проекта...

REM Проверяем наличие Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker не найден! Установите Docker и попробуйте снова.
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose не найден! Установите Docker Compose и попробуйте снова.
    pause
    exit /b 1
)

REM Проверяем файлы окружения
if not exist "codev\.env" (
    echo ⚠️ Файл codev\.env не найден!
    echo 📋 Скопируйте codev\env.template в codev\.env и настройте переменные.
    echo    copy codev\env.template codev\.env
    pause
    exit /b 1
)

if not exist "codev-bot\.env" (
    echo ⚠️ Файл codev-bot\.env не найден!
    echo 📋 Скопируйте codev-bot.env.template в codev-bot\.env и настройте переменные.
    echo    copy codev-bot.env.template codev-bot\.env
    pause
    exit /b 1
)

REM Запускаем проект
echo 🏗️ Собираем и запускаем контейнеры...
docker-compose up --build -d

echo ⏳ Ждем запуска сервисов...
timeout /t 10 /nobreak >nul

REM Проверяем статус
echo 📊 Статус сервисов:
docker-compose ps

echo.
echo ✅ Проект запущен!
echo 🌐 Веб-приложение: http://localhost:3000
echo 🤖 Telegram бот запущен и готов к работе
echo.
echo 📋 Полезные команды:
echo    docker-compose logs -f          # Логи всех сервисов
echo    docker-compose logs -f codev-web # Логи веб-приложения
echo    docker-compose logs -f codev-bot # Логи бота
echo    docker-compose down            # Остановить все сервисы

pause
