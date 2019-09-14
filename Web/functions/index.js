const functions = require('firebase-functions');
const app = require("./app");

exports.helloWorld = functions.https.onRequest(app);
