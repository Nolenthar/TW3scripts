#!/bin/bash

INPUT_FOLDER=$1
OUTPUT_FOLDER=$2

echo "Input folder is:"
echo "${INPUT_FOLDER}"

echo "Output folder is:"
echo "${OUTPUT_FOLDER}"

if ! [ -d ${OUTPUT_FOLDER} ]; then
	mkdir ${OUTPUT_FOLDER}
fi

cp -rf "${INPUT_FOLDER}/." "${OUTPUT_FOLDER}"

SCRIPT_FILES=`find "${OUTPUT_FOLDER}/" -type f`

IFS=$'\n'

for file in ${SCRIPT_FILES}; do
	#convert encoding and decomment
	iconv -f utf-16le -t utf8 -c "${file}" | ./decomment > "${file}.dec"
	#remove BOM leftover from iconv
	sed -i '1 s/^\xef\xbb\xbf//' "${file}.dec"
	#CR/LF to LF
	#sed -i 's/.$//' "${file}.dec" - this eats the last line if it doesn't have CR/LF
	dos2unix -q "${file}.dec"
	#add last empty line for sed to be happy
	sed -i '$a\' "${file}.dec"
	#remove empty lines and trailing whitespaces
	sed -i '/^$/d; /^\s*$/d; s/[[:blank:]]*$//' "${file}.dec"
	#LF to CR/LF
	unix2dos -q "${file}.dec"
	#convert back to utf-16le
	#iconv -f utf8 -t utf-16le -c "${file}.dec" > "${file}"
	mv -f "${file}.dec" "${file}"
done
