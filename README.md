# predix-edge-java-jre-1-11
A JRE using Java Modules and extending Alpine Linux to keep it small


## Docker Build

```bash
docker build --no-cache -t predixedge/predix-edge-java-jre-1-11:latest -f Dockerfile .
```

or with proxy

```bash
docker build --no-cache --build-arg https_proxy=$http_proxy --build-arg no_proxy=$no_proxy --build-arg http_proxy=$http_proxy -t predixedge/predix-edge-java-jre-1-11:latest -f Dockerfile .
```

## Docker Run

```bash
docker run predixedge/predix-edge-java-jre-1-11:latest 
```

[![Analytics](https://predix-beacon.appspot.com/UA-82773213-1/predix-edge-java-jre-1-11/readme?pixel)](https://github.com/PredixDev)
