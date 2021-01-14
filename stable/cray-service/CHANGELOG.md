# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]

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
