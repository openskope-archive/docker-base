#!/usr/bin/env bash

# run the tests and capture their outputs
echo ".......................... BEGIN DOCKER IMAGE SELF-TEST ........................"
${SELFTEST_DIR}/test.sh 2>&1 | tee ${SELFTEST_BASE}/actual.txt
echo "........................... END DOCKER IMAGE SELF-TEST ........................."

# detect differences in actual output from expected
diff ${SELFTEST_BASE}/expected.txt ${SELFTEST_BASE}/actual.txt > ${SELFTEST_BASE}/diff.txt

# fail docker image build if any differences detected
if [[ -s ${SELFTEST_BASE}/diff.txt ]] ; then
    echo "**** FAILURE - Docker image test outputs differ from expected *****"
    cat ${SELFTEST_BASE}/diff.txt
    exit 1
fi ;
