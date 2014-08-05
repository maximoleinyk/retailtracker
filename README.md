Retail Tracker
=============

Терминология:

- CRUD (Create Retrieve Update Delete)
- POS (Point of Sale)
- CI (Continuous Integration)

Целевая аудитория:

Владельцы розничных точек, которые хотят автоматизировать продажи и учет товара на складах. 

ПО включает в себя:

- складской учет
- оприходование и списане товара
- продажи и ведения класификации товара
- аналитика и статистика.
- печать документов

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
- Подумать по поводу локализации (Русский и Украинский)

# Версия 2 Складской учет

- Главная страница
  - Вывод последних 20 действий в системе (Кто, что, когда и где)
- Наименования
  - CRUD
- Единицы измерения
  - CRUD
- Склад
  - CRUD
  - Перемещение позиций со склада на склад
  - Добавить возможность оприходовать товар
  - Добавить возможность списать товар

# Версия 3 Управление POS терминалом

- Управление POS
  - CRUD для POS
    - Роль начальника
    - Роль продавца
  - Назначение ответственного (создатель POS назначает ответственного)
  - Продажа товара
  - Инкасация денежных средств из/в кассу
  
# Версия 4 Печать документов

- Возможность формирования любого отчета и сохранения в базу
- Возможность просмотра сквозного списка отчетов и скачивание
- Возможность поиска, сортировки и фильтрации

# Версия 5 Реорганизация кода и интеграция с платежными системами

















