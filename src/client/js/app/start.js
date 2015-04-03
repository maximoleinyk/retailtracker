define(['cs!app/common/moduleLoader', 'app/common/http', 'cookies'], function (ModuleLoader, http, cookies) {
	'use strict';

	if (document.documentElement.className.indexOf('no-support') > -1) {
		throw new Error('This application cannot be started in this browser.');
	}

	var cookie = document.cookie,
		cookieEnabled = navigator.cookieEnabled || ('cookie' in document && (cookie.length > 0 || (cookie = 'test').indexOf.call(cookie, 'test') > -1));

	document.documentElement.className += cookieEnabled ? ' cookies' : ' no-cookies';

	// set CSRF token from cookies
	http.setHeaders({
		'X-Csrf-Token': cookies.get('X-Csrf-Token')
	});

	// initialize whole module loading mechanism
	var loader = new ModuleLoader('/page/', {
		'account': 'account',
		'brand': 'brand',
		'company': 'company',
		'pos': 'pos'
	});
	loader.start('account');
});
