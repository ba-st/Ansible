# How to load Ansible in a Pharo image

## Using Metacello

1. Download a [Pharo VM and image](https://pharo.org/download)
2. Open your Pharo image
3. Open a Playground
4. Evaluate:

    ```smalltalk
    Metacello new
      baseline: 'Ansible';
      repository: 'github://ba-st/Ansible:release-candidate';
      load: 'Development'.
    ```

> Change `release-candidate` to some released version if you want a pinned version

## Using Iceberg

1. Download [pharo VM and image](https://pharo.org/download)
2. Open your Pharo image
3. Open Iceberg
4. Click the *Add* repository button
5. Select *Clone from github.com* and enter `ba-st` as owner name and `Ansible`
   as project name
6. Click *Ok*
7. Select the repository in the main Iceberg window
8. Open the contextual menu and select
  *Metacello -> Install baseline of Ansible ...*
9. Type `Development` and click *Ok*

> After Iceberg cloned a repository, it will be checked-out at the default
> branch (in this case `release-candidate`). If you want to work on a different
> branch or commit, perform the checkout before the baseline installation step.

## Running the Unit Tests

To run the unit tests you need a working RabbitMQ instance. The easier way is
to start one using docker:

```bash
docker run -d -p 5672:5672 rabbitmq:latest
```
