#! /bin/bash

# Move all "ORA-01861 literal does not match format string" errors in folder 125
# See issue https://github.com/OHDSI/DataQualityDashboard/issues/125

FOLDER="125/"
is_a_TXT_file(){
    filename=$1
    if [[ $filename == *.txt ]]
    then
        return 0;
    else
        return 1;
    fi
}

filenames=$(grep -lr "01861" ./)
for filename in $filenames
do
    if is_a_TXT_file $filename
    then
        output_file=$FOLDER/$filename
        mv $filename $output_file
    fi
done