#!/bin/sh

export APP_HOME=/usr/src/app/
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${APP_HOME}/bin:${APP_HOME}/sbin
cd $APP_HOME/bin
gunicorn -w 1 -t 60 -b :8080 --access-logfile - --error-logfile - run:app
