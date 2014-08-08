require("coffee-script/register");

global.inject = function(url) {
    return require('./src/server/' + url);
};

var app = inject('app'),
    path = require('path'),
    isDev = process.env.NODE_ENV === 'development';

app.start({
    cookieSecret: 'secret_cookie_word',
    sessionSecret: 'session_secret_word',
    staticDir: path.resolve(__dirname, isDev ? 'src/client' : 'build/client'),
    indexFile: path.resolve(__dirname, isDev ? 'src/client/index.html' : 'build/server/index.html'),
    socketPort: 4000,
    appPort: 3000,
    dbHost: '127.0.0.1',
    dbPort: '27017',
    dbName: 'retailtracker'
});
