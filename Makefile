#
# MIT License
#
# (C) Copyright 2019-2023 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# (MIT License)

CHART_PATH ?= kubernetes
CHART_NAME_1 ?= cray-service
CHART_NAME_2 ?= cray-jobs
CHART_NAME_3 ?= cray-postgresql
CHART_VERSION_1 ?= 0.0.0
CHART_VERSION_2 ?= 0.0.0
CHART_VERSION_3 ?= 0.0.0
UID := $(shell id -u)

# Tests are successful as of helm-unittest 3.11.2-0.3.0
HELM_UNITTEST_IMAGE ?= artifactory.algol60.net/csm-docker/stable/docker.io/quintush/helm-unittest:latest

charts: chart1 chart2 chart3 chart1_test chart2_test chart3_test

chart1:
	helm dep up ${CHART_PATH}/${CHART_NAME_1}
	helm package ${CHART_PATH}/${CHART_NAME_1} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_1}

chart2:
	helm dep up ${CHART_PATH}/${CHART_NAME_2}
	helm package ${CHART_PATH}/${CHART_NAME_2} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_2}

chart3:
	helm dep up ${CHART_PATH}/${CHART_NAME_3}
	helm package ${CHART_PATH}/${CHART_NAME_3} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_3}

chart1_test:
	helm lint "${CHART_PATH}/${CHART_NAME_1}"
	docker run --rm -u ${UID} -v ${PWD}/${CHART_PATH}:/apps ${HELM_UNITTEST_IMAGE} ${CHART_NAME_1}

chart2_test:
	helm lint "${CHART_PATH}/${CHART_NAME_2}"
	docker run --rm -u ${UID} -v ${PWD}/${CHART_PATH}:/apps ${HELM_UNITTEST_IMAGE} ${CHART_NAME_2}

chart3_test:
	helm lint "${CHART_PATH}/${CHART_NAME_3}"
	docker run --rm -u ${UID} -v ${PWD}/${CHART_PATH}:/apps ${HELM_UNITTEST_IMAGE} ${CHART_NAME_3}
