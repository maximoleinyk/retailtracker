require("coffee-script/register");

global.inject = function (url) {
	return require(require('path').resolve('./src/server/', url));
};

var app = inject('app'),
	path = require('path'),
	isDev = process.env.NODE_ENV === 'development';

app.start({
	app: {
		port: 3000,
		indexHtml: path.resolve(__dirname, isDev ? 'src/client/index.html' : 'build/server/index.html'),
		staticDir: path.resolve(__dirname, isDev ? 'src/client' : 'build/client'),
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
		templatesDir: path.resolve(__dirname + '/src/server/services/templates'),
		host: 'smtp.gmail.com',
		port: 587,
		user: 'retailtracker.noreply@gmail.com',
		pass: 'P@sSw0Rd'
	}
});
