
## Установка

Скачать и установить

  - http://nodejs.org/download/
  - http://mongodb.org/downloads
  - http://git-scm.com/download/win
   
  
Сделать копию проекта

  - git clone git@github.com:maximoleinyk/retailtracker.git

Скопировать из корня директории файл запуска БД (mongo.bat|mongo.sh) в корневую директорию mongodb и изменить в нем пути.
  
Конфигурация проекта Unix

  - npm install -g grunt-cli
  - npm install -g node-inspector
  - npm install -g bower
  - npm install
  - bower install
  - grunt
  
Конфигурация проекта Windows

  - npm install -g grunt-cli
  - npm install -g node-inspector
  - npm install -g bower
  - установить по пунктам https://github.com/TooTallNate/node-gyp#installation
  - npm install -g node-gyp
  - открыть файл addon.gypi в директории c:\Program Files\nodejs\node_modules\npm\node_modules\node-gyp\
  - добавить следующее после строчки [ 'OS=="win"', {
  
  'msvs_settings': {
    'VCLinkerTool': {
      'AdditionalLibraryDirectories': 'c:\\Program Files\\Microsoft SDKs\\Windows\\v7.1\\Lib\\x64'
    }
   },
  
  - npm install
  - bower install
  - grunt

Запуск приложения Unix

  - export NODE_ENV=development
  - moongo.sh (Unix) в установочной директории mongodb
  - node-inspector
  - npm start
  
Запуск приложения Windows

  - set NODE_ENV=development
  - mongo.bat (Windows) в установочной директории mongodb
  - node-inspector
  - npm start

Открываем два URL:

 - http://127.0.0.1:8080/debug?port=5858
 - http://localhost:3000/ui
 
Готово!
