#!/usr/bin/env node

var runCommand = require('run-command');

runCommand("bower", ['install']);
runCommand("gulp");
