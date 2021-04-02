# `cray-jobs` Base Chart

The purpose of this chart is to include it as a subchart in any other, and you have access to some easy ways of managing one or many [Kubernetes jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/).

## How to include this as a subchart

In your Helm chart, just add it to the `requirements.yaml` like:

```
---
dependencies:
  - name: cray-jobs
    version: "~0.1.0-0"
    repository: "@cray-internal"
```

You can then add the relevant part to your chart's `values.yaml`, something like:

```
cray-jobs:
  jobs:
    deployed:
      template:
        spec:
          containers:
            default:
              image:
                repository: cray-jobs-test
    pre-install:
      annotations:
        helm.sh/hook: "pre-install"
        helm.sh/hook-weight: "1"
        helm.sh/hook-delete-policy: "before-hook-creation"
      template:
        spec:
          containers:
            default:
              image:
                repository: cray-jobs-test
    pre-upgrade:
      annotations:
        helm.sh/hook: "pre-upgrade"
        helm.sh/hook-weight: "1"
        helm.sh/hook-delete-policy: "before-hook-creation"
      template:
        spec:
          containers:
            default:
              image:
                repository: cray-jobs-test
```

See the [values.yaml](./values.yaml) file in this base chart for more info on setting the values above.

## Use-cases and Requirements this Chart is Fulfilling

We'll look at this mostly in the context of how you'd set your `values.yaml`

### I need a job to run before I install or upgrade my service/chart

We simply want to set up our Helm hooks appropriately in this case. We want the job to run before we install the chart and before any upgrade of the chart as well:

```
cray-jobs:
  jobs:
    myjob:
      annotations:
        helm.sh/hook: "pre-install,pre-upgrade"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-weight: "1"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-delete-policy: "before-hook-creation"
      # ... other JobSpec values supported
      template:
        spec:
          containers:
            default:
              image:
                repository: my-job-container-image
        # ... JobSpec template
```

Notice the `helm.sh/hook-delete-policy: "before-hook-creation"`, which is telling Helm to delete any previous versions of the job before creating any new hook job. This is the default for Helm as well, so you could just leave it out and it would do the same.

### I need a job to run after I install or upgrade my service/chart

Pretty much the same as above, I just want to set my `helm.sh/hook` value with different things:

```
cray-jobs:
  jobs:
    myjob:
      annotations:
        helm.sh/hook: "post-install,post-upgrade"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-weight: "1"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-delete-policy: "before-hook-creation"
      # ... other JobSpec values supported
      template:
        spec:
          containers:
            default:
              image:
                repository: my-job-container-image
        # ... JobSpec template
```

### I need a job to run only once before I initially install my service/chart

If we tell Helm to only do `pre-install` as the hook, it'll only run before the initial install of a chart

```
cray-jobs:
  jobs:
    myjob:
      annotations:
        helm.sh/hook: "pre-install"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-weight: "1"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-delete-policy: "before-hook-creation"
      # ... other JobSpec values supported
      template:
        spec:
          containers:
            default:
              image:
                repository: my-job-container-image
        # ... JobSpec template
```

###  I need a job to run only once after I initially install my service/chart

Similarly, if you only want it to run after the initial install

```
cray-jobs:
  jobs:
    myjob:
      annotations:
        helm.sh/hook: "post-install"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-weight: "1"
        # optional value below here, will use Helm defaults if unset
        helm.sh/hook-delete-policy: "before-hook-creation"
      # ... other JobSpec values supported
      template:
        spec:
          containers:
            default:
              image:
                repository: my-job-container-image
        # ... JobSpec template
```

### I don’t own a service or other chart, I just need to run some jobs and want to deploy them via a chart

Now we get to jobs that don't utilize Helm hooks. You just want them to be deployed and executed along with your chart

```
cray-jobs:
  jobs:
    myjob:
      # ... JobSpec values supported
      template:
        spec:
          containers:
            default:
              image:
                repository: my-job-container-image
        # ... JobSpec template
```

You're pretty much just defining your JobSpec in values and letting the cray-jobs chart render it for you with some other things filled in and doing some other common Cray things like image repository manipulation, etc.

The other important thing to note with the above, is your job name will be rendered with the Helm release revision as a suffix. This ensures that Helm can continue to deploy the job continuously on both install and upgrade and cleaning up the job that was deployed and run on the previous release.

### I need to be able to deploy 1 or more jobs with a release, they should run on each release, and any that ran before shouldn’t block me from deploying new versions of the job(s)

This use-case was addressed in the previous section as well

### Completed (successful/failed) jobs should be cleaned up at some point

This is achieved in 3 ways:

1. A normal job deployed with your chart will have its name suffixed with the Helm release revision to ensure it gets cleaned up on the next upgrade
2. Helm hooks have built-in mechanisms for cleaning up previous hook jobs via the `helm.sh/hook-delete-policy` annotation
3. The Cray k8s cluster-level has mechanisms in place for cleaning up "Completed" resources
