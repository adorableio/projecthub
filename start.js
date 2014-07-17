#!/usr/bin/env node

var runCommand = require('run-command');

// Environment Variables!
var dotenv = require('dotenv');
dotenv.load()

console.log("# NODE_ENV: " + process.env.NODE_ENV);

runCommand("coffee", ['app.coffee']);
if (process.env.NODE_ENV == "development") {
  runCommand("gulp", ['watch-pre-tasks'], function() {
    runCommand("gulp", ['watch']);
  });
}
