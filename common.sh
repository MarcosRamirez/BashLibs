#!/bin/bash

function commandlog {
    if [[ $2 == "test" ]]; then
	log "[Execut'n (TEST)] $1"
	return
    fi
    log "[Execut'n] $1"
    startTime=`date +%s`
    eval "$1" | blogger --logFile "$logPath/$scriptName.log" -t "[DEBUG] $scriptName [$1]"
    endTime=`date +%s`
    let elapsedTime=$endTime-$startTime
    debug "[Executed (in $elapsedTime seconds)] $1"
}


function sucommandlog {
    log "[Sudoing!] $1"
    commandlog "su $1"
#    startTime=`date +%s`
#    eval "$1" | blogger --logFile "$logPath/$scriptName.log" -t "[DEBUG] $scriptName [$1]"
#    endTime=`date +%s`
#    let elapsedTime=$endTime-$startTime
#    debug "[Executed (in $elapsedTime seconds)] $1"
}


function log {
    if [[ $scriptName = "" ]]
    then
		scriptName="Script"
    fi
    if [[ $logPath = "" ]]
    then
		logPath="/var/log/Scripts/"
    fi
    generatedLogLine="$scriptName: $1"
    
    echo "$generatedLogLine" | blogger --logFile "$logPath/$scriptName.log"

    if [[ $SHELLOPTS = *"interactive"* ]]; then
	echo "$generatedLogLine"
#	debug "Interactive shell detected"
    fi
}

function instanceme {
    if [[ $lockFile == "" ]]; then
	debug "lock file not defined, setting default lockFile"
	lockFile="$scriptName.lock"
    fi
    if [ -f "/tmp/$lockFile" ]; then
	log "Another instance running, exiting..."
	exit
    else
	log "Instance initiated"
	touch "/tmp/$lockFile"
    fi
}

function deinstanceme {
    rm "/tmp/$lockFile"
}

function warning {
    log "[Warn] $1"
}

function debug {
    log "[DEBUG] $1"
}

function error {
    log "[ERROR] $1"
    logger -t "$scriptName" "[ERROR] $1"
}

function testReturn () {
    return "calimocho"
}

