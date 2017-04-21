#!/usr/bin/env bash

# run the tests and capture their outputs
echo ".......................... BEGIN DOCKER IMAGE SELF-TEST ........................"
${SELFTEST}/test.sh 2>&1 | tee ${SELFTEST}/actual.txt
echo "........................... END DOCKER IMAGE SELF-TEST ........................."

# detect differences in actual output from expected
diff ${SELFTEST}/expected.txt ${SELFTEST}/actual.txt > ${SELFTEST}/diff.txt

# fail docker image build if any differences detected
if [[ -s ${SELFTEST}/diff.txt ]] ; then
echo "**** FAILURE - Docker image test outputs differ from expected *****"
cat ${SELFTEST}/diff.txt
echo
exit 1
fi ;
