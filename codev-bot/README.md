# Codev Bot - Админ-панель для управления проектами

Telegram бот для команды Codev, который служит админ-панелью для управления портфолио проектов компании.

## 🚀 Функционал

- ✅ Авторизация по Telegram ID (только админы имеют доступ)
- ✅ Просмотр списка проектов с пагинацией (по 10 на страницу)
- ✅ Добавление новых проектов (название, описание, ссылка, изображение)
- ✅ Редактирование существующих проектов (все поля)
- ✅ Удаление проектов
- ✅ Управление админами (добавление, редактирование, удаление, просмотр списка)
- ✅ Отображение фото меню на всех сообщениях (настраивается через БД)
- ✅ Автоматическая загрузка изображений в imgbb
- ✅ Прогрессивный интерфейс добавления проектов с удалением предыдущих сообщений

## 📋 Требования

- Python 3.8+
- PostgreSQL
- Telegram Bot Token

## ⚙️ Установка

1. **Клонируйте проект** (если нужно) или используйте существующую папку

2. **Установите зависимости:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Создайте .env файл** в корне проекта:
   ```env
   BOT_TOKEN=your_telegram_bot_token_here
   DB=postgresql://user:password@localhost:5432/database_name
   IMGBB_API_KEY=your_imgbb_api_key_here
   ```
   
   Для получения IMGBB_API_KEY:
   - Зарегистрируйтесь на https://imgbb.com/
   - Перейдите в настройки API: https://api.imgbb.com/
   - Скопируйте ваш API ключ

4. **Создайте структуру базы данных** в PostgreSQL:
   ```sql
   -- Таблица настроек
   CREATE TABLE settings (
       id SERIAL PRIMARY KEY,
       key TEXT NOT NULL UNIQUE,
       value TEXT,
       created_at TIMESTAMP DEFAULT NOW() NOT NULL,
       updated_at TIMESTAMP DEFAULT NOW() NOT NULL
   );
   
   -- Настройка списка администраторов (JSON формат)
   INSERT INTO settings (key, value) VALUES 
   ('admin_telegram_ids', '["1215831955", "987654321", "111111111", "222222222"]');

   -- Таблица проектов
   CREATE TABLE projects (
       id SERIAL PRIMARY KEY,
       title TEXT NOT NULL,
       description TEXT,
       image_url TEXT,
       project_url TEXT,
       created_at TIMESTAMP DEFAULT NOW() NOT NULL,
       updated_at TIMESTAMP DEFAULT NOW() NOT NULL
   );

   -- Функция для автообновления updated_at
   CREATE OR REPLACE FUNCTION update_updated_at_column()
   RETURNS TRIGGER AS $$
   BEGIN
       NEW.updated_at = NOW();
       RETURN NEW;
   END;
   $$ language 'plpgsql';

   -- Триггеры для автообновления updated_at
   CREATE TRIGGER update_settings_updated_at BEFORE UPDATE ON settings
       FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
   CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
       FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
   ```

5. **Настройка фото меню** (опционально):
   Для отображения фото на всех сообщениях бота добавьте запись в таблицу settings:
   ```sql
   INSERT INTO settings (key, value) 
   VALUES ('menu_photo', 'https://your-image-url.com/photo.jpg')
   ON CONFLICT (key) 
   DO UPDATE SET value = 'https://your-image-url.com/photo.jpg';
   ```

6. **Миграция для существующей базы данных** (если у вас уже есть проекты):
   ```bash
   psql -d your_database -f migration_add_project_url.sql
   ```

## 🚀 Запуск

```bash
python main.py
```

## 👤 Первоначальная настройка админов

При первом запуске бота используйте команду `/add_admin` чтобы добавить себя как админа:

1. Напишите боту `/start`
2. Если у вас нет доступа, напишите `/add_admin`
3. Если в базе данных еще нет админов, вы станете первым админом
4. После этого вы сможете добавлять других админов через команду `/add_admin USER_ID`

## 📱 Использование

### Команды бота:
- `/start` - запуск бота и главное меню (только для админов)
- `/add_admin` - добавить себя как админа (только если нет других админов)
- `/add_admin USER_ID` - добавить пользователя как админа (только для существующих админов)

### Кнопки меню:
- **📂 Просмотреть проекты** - показать список всех проектов
- **➕ Добавить проект** - добавить новый проект с названием, описанием и изображением
- **🔧 Управление админами** - управление правами доступа

### Управление проектами:
- При просмотре проекта доступны кнопки редактирования и удаления
- Можно редактировать название, описание и URL изображения отдельно
- Удаление требует подтверждения

## 🗃️ Структура файлов

- `main.py` - основной файл запуска бота
- `config.py` - конфигурация и загрузка переменных окружения
- `database.py` - работа с PostgreSQL базой данных
- `handlers.py` - обработчики команд и callback'ов
- `keyboards.py` - инлайн клавиатуры для бота
- `requirements.txt` - зависимости Python

## 🔧 Технические детали

- **aiogram 3.4.1** - современная библиотека для Telegram Bot API
- **asyncpg** - асинхронный драйвер для PostgreSQL
- **python-dotenv** - загрузка переменных окружения
- **FSM (Finite State Machine)** - для обработки многошаговых диалогов
- **Inline клавиатуры** - для удобного управления через кнопки

## 🔒 Безопасность

- Доступ к боту имеют только пользователи с Telegram ID, сохраненными в таблице `settings`
- Все операции логируются
- Подтверждение для критических действий (удаление проектов)

## 📞 Поддержка

При возникновении проблем проверьте:
1. Правильность настройки .env файла
2. Доступность PostgreSQL базы данных
3. Валидность Telegram Bot Token
4. Логи приложения для диагностики ошибок

