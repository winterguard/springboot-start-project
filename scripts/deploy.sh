#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=springboot-start-project

echo "> Copy Build Files"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Check current activated application pid"

CURRENT_PID=$(pgrep -fl $PROJECT_NAME | grep java | awk '{print $1}')

echo "> Current activated application pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> Nothing Closed because there is not current activated application"
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> Deploy new Application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> Add Authority to $JAR_NAME"

chmod +x $JAR_NAME

echo "> Run $JAR_NAME"

nohup java -jar \
  -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
  -Dspring.profiles.active=real \
  $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &

