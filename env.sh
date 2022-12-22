#!/bin/bash

echo "Generating runtime env file..."

CONFIG_FILE='env-config.js'
ENV_FILE='/docker-entrypoint.d/.env.template'

while getopts ":l:" opt; do
  case ${opt} in
  l) # for local invocations, specify env file to use as arg
    ENV_FILE=$OPTARG
    CONFIG_FILE='public/env-config.js'
    mkdir -p public
    ;;
  \?)
    echo "Usage: cmd [-h] [-t]"
    ;;
  esac
done
shift $((OPTIND - 1))

# Recreate config file
rm -rf $CONFIG_FILE
touch $CONFIG_FILE

# Add assignment
echo "window.__env__ = {" >>$CONFIG_FILE

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]]; do
  # Ignore comments
  [[ "$line" =~ ^\#.*$ ]] && continue

  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}

  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >>$CONFIG_FILE
done <$ENV_FILE

echo "}" >>$CONFIG_FILE

echo "Runtime env file genrated:"
cat $CONFIG_FILE