#!/usr/bin/env sh

# Functions
_logdate() {
  echo `date +%y/%m/%d_%H:%M:%S`:: $*
}

_check_vars() {
  if [ ! ${DB_HOST} ]; then
    _logdate "[ERROR] DB_HOST environment variable must be defined."
    exit 1
  fi
  if [ ! ${DB_USER} ]; then
    _logdate "[ERROR] DB_USER environment variable must be defined."
    exit 1
  fi
  if [ ! ${DB_PASS} ]; then
    _logdate "[ERROR] DB_PASS environment variable must be defined."
    exit 1
  fi
}

_backup() {
  for database in $all_databases
  do
    mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASS} -B ${database} > ${BK_PATH:="/mnt"}/${database}_$(date +%Y%m%d-%H%M%S).sql
    if [ $? -eq 0 ]; then
      _logdate "[OK] Backup of database '${database}' made correctly on file ${BK_PATH:="/mnt"}/${database}_$(date +%Y%m%d-%H%M%S).sql."
    else
      _logdate "[ERROR] Something was wrong with backup of database '${database}'."
    fi
  done
}

# Check parameters
if [ -z $* ]; then
  _logdate "[ERROR] You must pass the database/s name as parameter."
  exit 1
else
  all_databases=$*
fi

# Main flow
_check_vars
_backup
