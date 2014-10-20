/*global ActiveXObject*/
/*global process*/
define(['handlebars'], function (Handlebars) {
    'use strict';

    var buildMap = [];

    var fs, getXhr,
        progIds = ['Msxml2.XMLHTTP', 'Microsoft.XMLHTTP', 'Msxml2.XMLHTTP.4.0'],
        fetchText = function () {
            throw new Error('Environment unsupported.');
        };

    if (typeof window !== 'undefined' && window.navigator && window.document) {
        getXhr = function () {
            var xhr, i, progId;
            if (typeof XMLHttpRequest !== 'undefined') {
                return new XMLHttpRequest();
            } else {
                for (i = 0; i < 3; i++) {
                    progId = progIds[i];
                    try {
                        xhr = new ActiveXObject(progId);
                    } catch (e) {
                    }

                    if (xhr) {
                        progIds = [progId]; // so faster next time
                        break;
                    }
                }
            }

            if (!xhr) {
                throw new Error('getXhr(): XMLHttpRequest not available');
            }

            return xhr;
        };

        fetchText = function (url, callback) {
            var xhr = getXhr();
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function (evt) {
                //Do not explicitly handle errors, those should be
                //visible via console output in the browser.
                if (xhr.readyState === 4) {
                    callback(xhr.responseText);
                }
            };
            xhr.send(null);
        };

    } else if (typeof process !== 'undefined' && process.versions && !!process.versions.node) {
        //Using special require.nodeRequire, something added by r.js.
        fs = require.nodeRequire('fs');
        fetchText = function (path, callback) {
            callback(fs.readFileSync(path, 'utf8'));
        };
    }

    return {

        load: function (name, parentRequire, load, config) {
            var ext = '.hbs';

            function findPartialDeps(text) {
                var matches = text.match(/{{>\s*([^\s]+?)\s*}}/ig),
                    res = [];
                for (var i in matches) {
                    if (matches.hasOwnProperty(i)) {
                        res.push(matches[i].split(' ')[1]);
                    }
                }
                return res;
            }

            var path = parentRequire.toUrl(name + ext);
            fetchText(path, function (text) {
                var deps = findPartialDeps(text),
                    depStr = deps.join('\', \'hbs!').replace(/_/g, '/');

                if (depStr) {
                    depStr = ',\'hbs!' + depStr + '\'';
                }

                var prec = Handlebars.precompile(text);
                text = 'define(\'hbs!' + name + '\',[\'handlebars\'' + depStr + '], function(Handlebars){' +
                    'var t = Handlebars.template(' + prec + ');' +
                    'Handlebars.registerPartial(\'' + name + '\', t);' +
                    'return t;});';

                //Hold on to the transformed text if a build.
                if (config.isBuild) {
                    buildMap[name] = text;
                }

                //IE with conditional comments on cannot handle the
                //sourceURL trick, so skip it if enabled.
                /*@if (@_jscript) @else @*/
                if (!config.isBuild) {
                    text += '\r\n//@ sourceURL=' + path;
                }
                /*@end@*/

                for (var i in deps) {
                    if (deps.hasOwnProperty(i)) {
                        deps[i] = 'hbs!' + deps[i].replace(/_/g, '/');
                    }
                }

                if (!config.isBuild) {
                    require(deps, function () {
                        load.fromText(name, text);

                        //Give result to load. Need to wait until the module
                        //is fully parse, which will happen after this
                        //execution.
                        parentRequire([name], function (value) {
                            load(value);
                        });
                    });
                } else {
                    load.fromText(name, text);

                    //Give result to load. Need to wait until the module
                    //is fully parse, which will happen after this
                    //execution.
                    parentRequire([name], function (value) {
                        load(value);
                    });
                }
            });
        }
    };
});