require("coffee-script/register");

var app = require('./src/server/app'),
    path = require('path'),
    isDev = process.env.NODE_ENV === 'development';

app.start({
    cookieSecret: 'secret_cookie_word',
    sessionSecret: 'session_secret_word',
    staticDir: path.resolve(__dirname, isDev ? 'src/client' : 'build/client'),
    indexFile: path.resolve(__dirname, isDev ? 'src/client/index.html' : 'build/server/index.html'),
    socketPort: 8001,
    appPort: 3000
});