#!/usr/bin/env node

if ((process.version.split('.')[1]|0) < 10) {
	console.log('Please, upgrade your node version to 0.10+');
	process.exit();
}

var net = require('net');
var util = require('util');
var crypto = require('crypto');
var readline = require('readline');

var options = {
	'port': 6969,
	'host': '54.83.207.90'
}

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

var KEYPHRASE;
rl.on('line', function (line) {
    KEYPHRASE = line.toString().trim();
});

//const KEYPHRASE = 'BurntOrangeExtremeWildcatIsFinal';

var dh2client, dh2server, secret2server, secret2client, state = 0;

var socket = net.connect(options, function() {
    state++;
});

function debug(msg) {
    //console.log(state + " : " + msg);
}
function socket_write(msg) {
    debug(msg);
    socket.write(msg);
}

socket.on('data', function(data) {

    debug(data.toString().trim());
	data = data.toString().trim().split(/[:|]/);
    data.shift();

	if (state == 1 && data[0] == 'hello?') {
        socket_write(data[0]);
        state++;
    } else if (state == 2 && data[0] == 'hello!') {
        socket_write(data[0]);
        state++;
    } else if (state == 3 && data[0] == 'key') {
        // for reply to client as server
        dh2client = crypto.createDiffieHellman(data[1], 'hex');
        dh2client.generateKeys();
        secret2client = dh2client.computeSecret(data[2], 'hex');
        // ask to server as client
		dh2server = crypto.createDiffieHellman(256);
		dh2server.generateKeys();
        socket_write(util.format('key|%s|%s\n', dh2server.getPrime('hex'), dh2server.getPublicKey('hex')));
		state++;
	} else if (state == 4 && data[0] == 'key') {
        //replace response
        socket_write(util.format('key|%s\n', dh2client.getPublicKey('hex')));
        state++;

        // handle reply from server to client
        secret2server = dh2server.computeSecret(data[1], 'hex');
    } else if (state == 5 && data[0] == 'keyphrase') {
        // save keyphrase??¿ ?¿?

        // replace with my keyphrase
        var cipher = crypto.createCipheriv('aes-256-ecb', secret2server, '');
        var keyphrase = cipher.update(KEYPHRASE, 'utf8', 'hex') + cipher.final('hex');
        socket_write(util.format('keyphrase|%s\n', keyphrase));
        state++;
    } else if (state == 6 && data[0] == 'result') {
		var decipher = crypto.createDecipheriv('aes-256-ecb', secret2server, '');
		var message = decipher.update(data[1], 'hex', 'utf8') + decipher.final('utf8');
		console.log(message);

        // reply to client
        var cipher = crypto.createCipheriv('aes-256-ecb', secret2client, '');
        var result = cipher.update(message, 'utf8', 'hex') + cipher.final('hex');
        socket_write(util.format('result|%s\n', result));

        socket.end();
	} else {
		console.log('Error');
		socket.end();
	}

});
