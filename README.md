
## Установка

Скачать и установить

  - http://nodejs.org/download/
  - http://mongodb.org/downloads
  - http://git-scm.com/download/win


Сделать копию проекта

  - git clone git@github.com:maximoleinyk/retailregister.git

Скопировать из корня проекта mongo.bat и mongo.sh в корневую директорию mongodb и изменить пути внутри файлов.

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
  - добавить 'msvs_settings': {
    'VCLinkerTool': {
      'AdditionalLibraryDirectories': 'c:\\Program Files\\Microsoft SDKs\\Windows\\v7.1\\Lib\\x64'
    }
   }, после строчки [ 'OS=="win"', {
  - npm install
  - bower install
  - grunt

Запуск приложения Unix

  - export NODE_ENV=development
  - moongo.sh в установочной директории mongodb
  - node-inspector
  - npm start

Запуск приложения Windows

  - set NODE_ENV=development
  - mongo.bat в установочной директории mongodb
  - node-inspector
  - npm start

Открываем два URL:

 - http://127.0.0.1:8080/debug?port=5858
 - http://localhost:3000/page/account/

Готово!!
