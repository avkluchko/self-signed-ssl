#!/usr/bin/env bash

OUTPUT_FILE="rootCA"
DAYS=1825 # 5 years

while getopts o:d: option
  do
    case "${option}" in
      o) OUTPUT_FILE=${OPTARG};;
      d) DAYS=${OPTARG};;
    esac
done

openssl genrsa -out $OUTPUT_FILE.key 4096

openssl req -x509 -new -sha256 -days 3650 -nodes \
    -key $OUTPUT_FILE.key -out $OUTPUT_FILE.pem