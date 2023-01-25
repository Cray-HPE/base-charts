#
# MIT License
#
# (C) Copyright 2019-2022 Hewlett Packard Enterprise Development LP
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
CHART_VERSION_1 ?= local
CHART_VERSION_2 ?= local
COMMA := ,
#HELM_UNITTEST_IMAGE ?= artifactory.algol60.net/csm-docker/stable/docker.io/quintush/helm-unittest
HELM_UNITTEST_IMAGE ?= quintush/helm-unittest:3.3.0-0.2.5
HELM_IMAGE ?= artifactory.algol60.net/csm-docker/stable/docker.io/alpine/helm:3.9.4

ifeq ($(shell uname -s),Darwin)
	HELM_CONFIG_HOME ?= $(HOME)/Library/Preferences/helm
else
	HELM_CONFIG_HOME ?= $(HOME)/.config/helm
endif

helm:
	docker run --rm \
	    --user $(shell id -u):$(shell id -g) \
	    --mount type=bind,src="$(shell pwd)",dst=/src \
	    $(if $(wildcard $(HELM_CONFIG_HOME)/.),--mount type=bind$(COMMA)src=$(HELM_CONFIG_HOME)$(COMMA)dst=/tmp/.helm/config) \
	    -w /src \
	    -e HELM_CACHE_HOME=/src/.helm/cache \
	    -e HELM_CONFIG_HOME=/tmp/.helm/config \
	    -e HELM_DATA_HOME=/src/.helm/data \
	    $(HELM_IMAGE) \
	    $(CMD)

charts: chart1 chart2 chart1_test chart2_test

chart1:
	CMD="dep up ${CHART_PATH}/${CHART_NAME_1}" $(MAKE) helm
	CMD="package ${CHART_PATH}/${CHART_NAME_1} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_1}" $(MAKE) helm

chart2:
	CMD="dep up ${CHART_PATH}/${CHART_NAME_2}" $(MAKE) helm
	CMD="package ${CHART_PATH}/${CHART_NAME_2} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_2}" $(MAKE) helm

chart1_test:
	CMD="lint ${CHART_PATH}/${CHART_NAME_1}" $(MAKE) helm
	docker run --rm -v ${PWD}/${CHART_PATH}:/apps ${HELM_UNITTEST_IMAGE} -3 ${CHART_NAME_1}

chart2_test:
	CMD="lint ${CHART_PATH}/${CHART_NAME_2}" $(MAKE) helm
	docker run --rm -v ${PWD}/${CHART_PATH}:/apps ${HELM_UNITTEST_IMAGE} -3 ${CHART_NAME_2}
