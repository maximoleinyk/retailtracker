require("coffee-script/register");

global.inject = function (url) {
	return require(require('path').resolve('./src/server/', url));
};

var path = require('path'),
	isProduction = process.env.NODE_ENV === 'production',
	config = {
        resourcesDir: path.resolve(__dirname + '/resources'),
		app: {
			port: 3000,
			indexHtml: path.resolve(__dirname + (isProduction ? '/build/server/index.html' : '/src/client/index.html')),
			staticDir: path.resolve(__dirname + (isProduction ? '/build/client' : '/src/client')),
			cookieSecret: 'secret_cookie_word',
			sessionSecret: 'session_secret_word'
		},
		socket: {
			port: 4000
		},
		db: {
			host: '127.0.0.1',
			port: '27017',
			name: 'retailtracker'
		},
		mailer: {
			templatesDir: path.resolve(__dirname + '/src/server/email/templates'),
			host: 'smtp.gmail.com',
			port: 587,
			user: 'retailtracker.noreply@gmail.com',
			pass: 'P@sSw0Rd'
		},
		cookie: {
			maxAge: 1000 * 60 * 60 * 2
		}
	};

global.config = config;

var App = inject('app');

new App(config).start();
