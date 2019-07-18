# Postal in Docker

Postal is a great piece of software. But I transfered all my software stacks to Docker. Therefore I required Docker container for postal. :-)

After a short search at github.com and I found a lot of repositories with Docker and postal. A few were empty. A few were crazy and three of them were really well. I decided to add a own Docker container in the source repository of postal. So I will take the best from the other repositories and add my own Docker knowledge and add this Files to postal repository.

## Instructions

Change configuration in docker-compose.yml to update passwords for MySQL/RabbitMQ. Note that both passwords in the `postal` service, `mysql` service and `rabbitmq` service have to be changed to the same values.

### Initialize Database and write assets

```docker-compose run --rm postal initialize```

### Create User

```docker-compose run --rm postal make-user```

### Running Container

After configuration is done, run the following to bring the container up.
```
docker-compose up -d
```

## Using the `postal` tool.

To use the `postal` tool, simply run
```
docker-compose run postal <parameter>
```
For example, the following command runs `postal initialize` inside the container.
```
docker-compose run postal initialize
```

## Migrations

See https://github.com/atech/postal/wiki/Upgrading. Note that building a new container (or pulling a new version from Docker Hub) will update the files in postal, so all you have to run is `postal upgrade` after building or retrieving the new container. Updating postal using its auto-update feature is highly not reccomended and likely does not work properly.

## Activate Travis-CI for this repository

To activate travis-ci:
1. Login to travis-ci.org with your Github.com username
2. Activate the `postal` repository
3. Add environment variables:
   1. `DOCKER_USERNAME`
   2. `DOCKER_PASSWORD`
   3. `DOCKER_REPO_NAME`
4. Have fun!

## Updates

- v2.0.0
  * Update to more reliable version of YAML management system
  * Split into ubuntu and alpine images
  * Moved to CircleCI for more advanced building
- v1.0.0
  * Initial Release


## Acknowledgement

This repo was built from scratch with the support of:
- https://github.com/appjumpstart/docker-postal
- https://github.com/Brightside56/postal-docker
- https://github.com/CatDeployed/docker-postal