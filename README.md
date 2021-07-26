# Volatility 2 - Docker Image

This repository contains a Dockerfile for building the [Volatility2](https://github.com/volatilityfoundation/volatility) DFIR memory analysis framework. It currently bases on Ubuntu Bionic for convenience, however this may change in the future.

### Usage
There are two directories specifically for mounting from the host, `/dumps` and `/host`. The recommended usage is to create a function inside `${HOME}/.bashrc` or `${HOME}/.zsh` as a convencience wrapper. This assumes a directory called `./dumps/` exists on the host, but will be mounted as readonly. The current directory is also mounted in the container, and a `logs` directory created, so that all commands can have their output saved to to the host.

**Basic Function**
```shell
function volatility()
{
	docker run --rm --volume "$(pwd)":"/host" --volume="$(pwd)/dumps":"/dumps:ro" misterturtlesec/volatility2 $@
}
```
  
**Automatic Logging**
```shell
function volatility()
{
        [[ ! -d "$(pwd)/volatility-logs/" ]] && {
                if ! mkdir -p "$(pwd)/volatility-logs/"; then
                        echo "Failed to create a logs directory. Check permissions"
                        return 1
                fi
        }
        args=$@
        logfile="$(date "+%Y%m%d-%H%M%S")-volatility"
        for arg in $args
        do
                arg="$( echo "${arg}" | sed -r 's/-/_/g')"
                logfile="${logfile}-${arg}"
        done
       logdir="${logfile}.log"
        docker run --rm --volume "$(pwd)":"/host" --volume="$(pwd)/dumps":"/dumps:ro" misterturtlesec/volatility2 $@ | tee -a "$(pwd)/volatility-logs/${logfile}"
}
```
  
**Shell in new container**
```shell
function volatility_shell()
{
	docker run --rm --volume "$(pwd)":"/host" --volume="$(pwd)/dumps":"/dumps:ro" --entrypoint=/bin/bash misterturtlesec/volatility2
}
```
### Profiles
If you require additional profiles in the volatility image, you can either customize the Dockerfile to include your custom profile with the below addition, or use `volatility_shell` and copy the profile from the `/host` directory into `/volatility/volatility/plugins/overlay/{os}/` directory.
```Dockerfile
ADD ./profile/x /volatility/volatility/plugins/overlay/{os}/x`
```

### Building
The image can be built locally with the following command:
```
docker build -t myvolatility .
```
