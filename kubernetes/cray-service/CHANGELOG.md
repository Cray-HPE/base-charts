# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

## [8.2.3]
### Changed
- The default tag for cray-postgres-db-backup is now 0.2.3 to fix a restore issue (CASMPET-5936).

## [8.2.2]
### Changed
- The default tag for cray-postgres-db-backup is now 0.2.2 to pick up security fixes.

## [8.2.1]
### Changed
- Add support for adding labels to pods for deployments, daemonsets and
  statefulsets.

## [8.2.0]
### Changed
- Allow 127.0.0.6 access to postgres server without TLS. This provides access to
  the Postgres server within the Istio Mesh without requiring an additional TLS
  layer.

## [8.1.4]
### Changed
- Fix etcd issues with image tags and TLS
- Enable TLS externally via cert-manager for postgresql

## [8.1.2]
### Changed
- Updated pgbouncer image version to the latest (master-21) built from upstream

## [8.1.1]
### Changed
- The default tag for the cray-postgres-db-backup is now 0.2.1 to pick up security fixes.

## [8.1.0]
### Changed
- Updated pgbouncer image version to the latest from upstream

## [8.0.0]
### Changed
- Added the ability to specify multiple TRSWorker resources.
- When creating a TRSWorker resource the desired TRS Worker container image tag needs be specified to allow the TRS Operator to correctly create the TRS Worker pods with a valid container image tag.

## [7.0.0]
### Changed
- Updated chart to apiVersion v2 and refactored image references to remove dtr.dev.cray.com

## [6.2.0]
### Changed
- Added the option (podPriorityClassName) to set pod priority for etcd cluster pods

## [6.1.0]
### Changed
- Added the option to set a startupProbe when configuring a container

## [6.0.0]
### Changed
- The wait-for-postgres container is configured to run as the nobody user.

## [4.0.0]
### Changed
- The default container securityContext now sets runAsUser, runAsGroup, and runAsNonRoot.

## [3.0.0]
### Changed
- Updated to support multiple istio-ingress gateways.

## [2.8.0]
### Added
- New options added to support pod priorities for postgres clusters, deployments, statefulsets and daemonsets.

## [2.7.0]
### Added
- New options are added to enable an automatic backup of the PostgreSQL database. Users must opt-in.

## [2.4.5]
### Changed
- The cache/postgres image was updated to pick up fixes for security vulnerabilities

## [2.4.1]
### Changed
- The volumeClaimTemplate section for the statefulset template is optional. The entire section is included only if configured in values.yaml

## [2.4.0]
### Changed
- The statefulset template now includes the volumeClaimTemplate section, and the default values file is updated with a default case. This is used to create the pvc items for each replica. The pvs will be created using the specified storage class; if none is specified, the global value will be used, and if that is also not set, the default class will be used. 

## [2.1.0]
### Changed
- Labels are now set on the -postgres-* Services.

## [1.11.1]
### Changed
- The `traffic.sidecar.istio.io/excludeOutboundPorts: 2379,2380` annotation is
  added when using etcd and annotations aren't overridden. If annotations are
  overwritten and etcd is used this annotation has to be added by the user.
  If this annotation is already there then these ports need to be added.

## [1.10.0]
### Changed
- The `status.sidecar.istio.io/port` annotation is no longer set when `service.enabled` is false.

## [1.4.0] - 2020-04
### Changed
- Container image tags now default to global.appVersion field

### Migrating
In order to migrate to this version, teams are required to do the following:
- Update your charts requirements.yaml to point to version 1.4.0 of the base chart
- Remove the `image.tag` from your main containers values.yaml
- Ensure any additional containers in your values.yaml that should not match your appVersion field have the `image.tag` value populated
