# Unit Tests for Helm Charts

This directory defines unit tests for charts using
https://github.com/quintush/helm-unittest. Get started testing by running the
following from the top-level chart directory:

```
$ helm plugin install https://github.com/quintush/helm-unittest
$ helm unittest -3 .

### Chart [ cray-service ] .

 PASS  deployment all container fields test	tests/deployment-all-container-fields_test.yaml
 PASS  deployment ensure custom service account set	tests/deployment-custom-sa_test.yaml
 PASS  deployment defaults	tests/deployment-defaults_test.yaml
 PASS  deployment env test	tests/deployment-env_test.yaml
 PASS  deployment test for etcd enabled	tests/deployment-etcd-enabled_test.yaml
 PASS  deployment ingress test	tests/deployment-ingress_test.yaml
 PASS  deployment all initContainers fields test	tests/deployment-initcontainer_test.yaml
 PASS  deployment test for sql enabled	tests/deployment-kafka-enabled_test.yaml
 PASS  deployment test for pod annotations	tests/deployment-pod-annotations_test.yaml
 PASS  deployment pvcs test	tests/deployment-pvcs_test.yaml
 PASS  deployment service disabled	tests/deployment-service-disabled_test.yaml
 PASS  deployment test for sql backup enabled	tests/deployment-sql-backup_test.yaml
 PASS  deployment test for sql enabled	tests/deployment-sql-enabled_test.yaml
 PASS  deployment test customisable update strategy	tests/deployment-update-strategy_test.yaml
 PASS  deployment test for volumes list	tests/deployment-volumes_test.yaml
 PASS  deployment test for conditional whitespace scenarios	tests/deployment-whitespace_test.yaml
 PASS  deployment test for volumes list	tests/statefulset-volumeclaimtemplate_test.yaml

Charts:      1 passed, 1 total
Test Suites: 17 passed, 17 total
Tests:       120 passed, 120 total
Snapshot:    0 passed, 0 total
Time:        619.692211ms

```

The `.values` directory here is useful for placing in values files for
alternative/manual testing/validation using `helm template ...`

[Writing standard helm chart
tests](https://github.com/helm/helm/blob/master/docs/chart_tests.md) in
`templates/` is also encouraged
