# General
Used RAML: [world-music-api](world-music-api)

NodeJS version: 13.5.0

Versions:
* osprey:
  * master: a306d8e879cb5e18cfcd06ba8fca56c883957d0a
  * rework_webapi_parser: 828169c3bbba0e539972d9b63eba07704d066968
* osprey-mock-service:
  * master: 8cc6b778b2aaae050a5f01ff338f2a29b679ec48
  * rework_webapi_parser: 35b392e5e9607750ad5ea67e614b70ba61568f80

# osprey

## Setup
To test Osprey from `master`, install it via npm:
```sh
cd ./app
npm install
```

To test `osprey` from `rework_webapi_parser` branch, install it via Makefile and link it to osprey app:
```sh
cd ./app
npm install
make clone
make install
make link-osprey
make link
```

Osprey app code can be found in [osprey-app.js](./src/osprey-app.js).

## Request/response time

### Setup
Installation:
```sh
sudo apt install apache2-utils
```

Start server with:
```sh
node osprey-app.js
```

Make requests and profile with (this makes 50000 requests with 10 concurrency):
```sh
ab -c 10 -n 50000 -H "Accept: application/json" -H "Authorization: qwe" "http://localhost:3000/songs?genre=foo&access_token=123"
```

### master
```
Document Path:          /songs?genre=foo&access_token=123
Document Length:        41 bytes

Concurrency Level:      10
Time taken for tests:   21.681 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      12400000 bytes
HTML transferred:       2050000 bytes
Requests per second:    2306.20 [#/sec] (mean)
Time per request:       4.336 [ms] (mean)
Time per request:       0.434 [ms] (mean, across all concurrent requests)
Transfer rate:          558.53 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     2    4   0.9      4      21
Waiting:        2    3   0.9      3      20
Total:          2    4   0.9      4      21

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      5
  90%      5
  95%      6
  98%      7
  99%      8
 100%     21 (longest request)
```

### rework_webapi_parser
```
Document Path:          /songs?genre=foo&access_token=123
Document Length:        41 bytes

Concurrency Level:      10
Time taken for tests:   14.197 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      12400000 bytes
HTML transferred:       2050000 bytes
Requests per second:    3521.78 [#/sec] (mean)
Time per request:       2.839 [ms] (mean)
Time per request:       0.284 [ms] (mean, across all concurrent requests)
Transfer rate:          852.93 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     1    3   0.9      3      50
Waiting:        1    2   0.8      2      49
Total:          1    3   0.9      3      50

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      3
  80%      3
  90%      4
  95%      4
  98%      5
  99%      6
 100%     50 (longest request)
```

## CPU and memory usage
### Setup
Installation:
```sh
sudo pip install psrecord
sudo apt-get install python-matplotlib python-tk
npm install -g artillery
```

In three different terminals:

1. Start server with:
```sh
node osprey-app.js
```

2. Start profiler:
```sh
psrecord $(pgrep node -n) --interval 1 --plot osprey.png
```

3. Start `artillery` to generate requests:
```sh
artillery run osprey.yml
```

When `artillery` finishes making requests, switch to the tab with the profiler running, press `Ctrl+C` and wait for it to draw a plot. When it finishes you can view plot with graph in a `osprey.png` file.

### master
![](osprey-master-cpu-memory.png)
### rework_webapi_parser
![](osprey-rework_webapi_parser-cpu-memory.png)

# osprey-mock-service
## Setup
To test `osprey-mock-service` from `master`, install it globally via npm:
```sh
npm install -g osprey-mock-service
```
and call it with `osprey-mock-service` command during profiling.

To test `osprey-mock-service` from `rework_webapi_parser` branch, install it via Makefile:
```sh
make all
```
and call it with `node path/to/cloned/mock/bin/osprey-mock-service.js`.


## Request/response time
### Setup
Installation:
```sh
sudo apt install apache2-utils
```

Start server with:
```sh
osprey-mock-service -f /path/to/osprey-profiling/world-music-api/api.raml -p 3000
```

Make requests and profile with (this makes 50000 requests with 10 concurrency):
```sh
ab -c 10 -n 50000 -H "Accept: application/json" -H "Authorization: qwe" "http://localhost:3000/v1/songs?genre=foo&access_token=123"
```

### master
```
Document Path:          /v1/songs?genre=foo&access_token=123
Document Length:        0 bytes

Concurrency Level:      10
Time taken for tests:   21.649 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      3750000 bytes
HTML transferred:       0 bytes
Requests per second:    2309.53 [#/sec] (mean)
Time per request:       4.330 [ms] (mean)
Time per request:       0.433 [ms] (mean, across all concurrent requests)
Transfer rate:          169.16 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0      14
Processing:     1    4   1.4      4     214
Waiting:        1    4   1.4      4     212
Total:          1    4   1.4      4     214

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      5
  80%      5
  90%      5
  95%      6
  98%      7
  99%      8
 100%    214 (longest request)
```

### rework_webapi_parser
```
Document Path:          /v1/songs?genre=foo&access_token=123
Document Length:        0 bytes

Concurrency Level:      10
Time taken for tests:   19.551 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      3750000 bytes
HTML transferred:       0 bytes
Requests per second:    2557.47 [#/sec] (mean)
Time per request:       3.910 [ms] (mean)
Time per request:       0.391 [ms] (mean, across all concurrent requests)
Transfer rate:          187.31 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       2
Processing:     1    4   2.5      3     211
Waiting:        1    3   2.4      3     211
Total:          1    4   2.5      3     211

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      4
  75%      4
  80%      4
  90%      5
  95%      6
  98%      8
  99%     10
 100%    211 (longest request)
```

## CPU and memory usage
### Setup
Installation:
```sh
sudo pip install psrecord
sudo apt-get install python-matplotlib python-tk
npm install -g artillery
```

In three different terminals:

1. Start server with:
```sh
osprey-mock-service -f /path/to/osprey-profiling/world-music-api/api.raml -p 3000
```

2. Start profiler:
```sh
psrecord $(pgrep node -n) --interval 1 --plot osprey-mock.png
```

3. Start `artillery` to generate requests:
```sh
artillery run osprey-mock-service.yml
```

When `artillery` finishes making requests, switch to the tab with the profiler running, press `Ctrl+C` and wait for it to draw a plot. When it finishes you can view plot with graph in a `osprey.png` file.

### master
![](osprey-mock-service-master-cpu-memory.png)
### rework_webapi_parser
![](osprey-mock-service-rework_webapi_parser-cpu-memory.png)
