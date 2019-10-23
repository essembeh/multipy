# MultiPy

Docker image containing
- Python 3.4
- Python 3.5 (default python in Debian Stretch)
- Python 3.6
- Python 3.7
- Python 3.8
- Tox

```sh
$ cd myproject/
$ docker run --rm --volume $PWD:/src:ro essembeh/multipy:latest sh -c 'cp -R /src ~/src && cd ~/src && tox'
```
