[![](https://images.microbadger.com/badges/version/essembeh/multipy.svg)](https://microbadger.com/images/essembeh/multipy "MultiPy")

# MultiPy

MultiPy is a [Docker](https://docker.io) image to use Python [Tox](https://tox.readthedocs.io) with `py34`, `py35`, `py36`, `py37` and `py38` environments.

The docker image contains:
- Python 3.4: installed from sources
- Python 3.5: packaged in Debian Stretch
- Python 3.6: installed from sources
- Python 3.7: installed from sources
- Python 3.8: installed from sources
- Tox: installed with `pip`
- an `entrypoint.sh` to simplify the usage

# Usage

The entrypoint copy the project from `/src/` before running `tox` to avoid creating dirty files in project folder:

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src:ro essembeh/multipy:latest
```

## Tox arguments

Arguments passed to the entrypoint will be given to *tox*:

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src:ro essembeh/multipy:latest -v -re py36
```

## Git clean

If the `/src/` folder is a *Git* repository, you can perform a `git clean -fdX` by setting `GIT_CLEAN` at runtime:

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src:ro -e GIT_CLEAN=1 essembeh/multipy:latest
```

## Custom volume

If for some reason, you mount the project folder into another volume, use `SRC_DIR` env variable:

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src2:ro -e SRC_DIR=/src2 essembeh/multipy:latest
```


# Customize the image

You can build your own image with extra *APT* packages using `--build-arg` to set `APT_EXTRA_PACKAGES`:

```sh
$ docker build --build-arg APT_EXTRA_PACKAGES="gnupg zsh" --tag mymultipy:latest https://github.com/essembeh/multipy.git
```

Then, you can use your own image `mymultipy:latest` which contains `gnupg` and `zsh`

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src:ro mymultipy:latest
```