
## Установка

Скачать и установить

  - http://nodejs.org/download/
  - http://mongodb.org/downloads
  - http://git-scm.com/download/win
   
  
Сделать копию проекта

  - git clone git@github.com:maximoleinyk/retailtracker.git

Скопировать из корня директории файл запуска БД (mongo.bat|mongo.sh) в корневую директорию mongodb и изменить в нем пути.
  
Выполнить команды в корне проекта

  - npm install -g grunt-cli
  - npm install -g node-inspector
  - npm install -g bower
  - npm install
  - bower install
  - grunt

Запуск приложения

  - mongo.bat (Windows) | moongo.sh (Unix) в установочной директории mongodb
  - node-inspector
  - npm start

Открываем два URL:

 - http://127.0.0.1:8080/debug?port=5858
 - http://localhost:3000/ui
 
Готово!
