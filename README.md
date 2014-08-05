Retail Tracker
=============

Терминология:

- CRUD (Create Retrieve Update Delete)
- POS (Point of Sale)
- CI (Continuous Integration)

Целевая аудитория:

Владельцы розничных точек, которые хотят автоматизировать свой бизнес. Программа складского учета, оприходования и списаня товара, продажи и ведения класификации товара, аналитика и статистика.

# Версия 1 Создание архитектуры

- Initial setup
  - Сформировать архитектуру на клиенте
    - сформировать модули и библиотеки на клиенте
    - добавить Twitter Bootstrap
  - Сформровать архитектуру на сервере
    - добавить mongodb определиться с библиотекой
    - добавить express.js 
    - добавить passport механизм аутентификации
  - Добавить навигационную панель
    - Ссылка учетная запись (Настройки)
    - Кнопка logout
- Учетная ззапись 
  - Регистрация (логин, пароль, проверка пароля) 
  - Вход/Выход (логин, пароль)
  - Забыли пароль (ввод логина, генерация временного пароля)
  - Смена пароля (старый пароль, новый пароль, подтверждение)
- Настройки
  - Возможность изменить имя и фамилию
  - Возможность изменить пароль
- Создание редактируемой таблицы

# Версия 2 Складской учет

- Main page
  - Вывод последних 20 действий в системе (Кто, что, когда и где)
- Склад
  - Добавить возможность оприходовать товар
  - Добавить возможность списать товар
- Наименования
  - CRUD
- Единицы измерения
  - CRUD

# Версия 3 Управление POS терминалом

- Управление POS (Point of Sale точка продажи)
  - CRUD для POS
    - Роль начальника
    - Роль продавца
  - Назначение ответственного
  - Продажа товара 
  - Инкасация денежных средств с/в кассу














