#!/bin/bash
source /root/.profile

if [ -z "$SMTP_HOST" ] || [ "$SMTP_HOST" == "false" ];then
    echo "Variable SMTP_HOST is not set, cannot send summary mail."
    exit 1
fi

SMTP_USER_PARAM=""
if [ -n "$SMTP_USER" ] && [ "$SMTP_USER" != "false" ]; then
    SMTP_USER_PARAM="-xu $SMTP_USER"
fi

SMTP_PASSWORD_PARAM=""
if [ -n "$SMTP_PASSWORD" ] && [ "$SMTP_PASSWORD" != "false" ]; then
    SMTP_PASSWORD_PARAM="-xp $SMTP_PASSWORD"
fi

echo "`date +\%Y/\%m/\%d\ \%H:%M:%S` `hostname` Sending summary mail"
{ echo "`df -h /sync/`"; printf "\n\n"; for D in `find /sync/ -type d | grep -i backups | sort`; do echo "${D}" && ls -lath ${D} | head -n 10 && printf "\n\n"; done; } | sendEmail -f backup@taktik.be -t "$SUMMARY_MAIL_TO" -u "`date +\%Y-\%m-\%d` `hostname` Daily backup report" -s $SMTP_HOST $SMTP_USER_PARAM $SMTP_PASSWORD_PARAM
