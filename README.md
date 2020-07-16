# Osprey Profiling
## [`webapi-parser`](https://github.com/raml-org/webapi-parser) refactoring: before vs after

* RAML used to test: [world-music-api](world-music-api)
* NodeJS: v14.5.0
* Versions:
  * osprey:
    * master (v0.6.1): be5c2e5f54f662556e666d19ffd705efd687e302
    * rework_webapi_parser: 73c1563f34eebcf2265077c8b01566c77c631e6f
  * osprey-mock-service:
    * master (v0.5.1): 543c75c38ed23b342840ee9519c67319e3851350
    * rework_webapi_parser: 388f0355ad81ccb09b654c033425c53215a1ebf1

## Summary
Based on profiling results produced by a specific profiling techniques used and a test application, following conclusions can be made:

**Osprey.** After the rework with `webapi-parser`:
  * An average time per request decreased by ~37%;
  * Number of requests an application is able to serve per second increased by  ~60%;
  * Average CPU usage stayed roughly the same with periodic 6x spikes;
  * Real memory usage increased from 80-110mb to 150-175mb.

**Osprey-mock-service.** After the rework with `webapi-parser`:
  * An average time per request decreased by ~9% (4.3s to 3.9s);
  * Number of requests an application is able to serve per second increased by  ~9% (2300 to 2500);
  * Average CPU usage stayed roughly the same with periodic spikes increasing from 11% to 22%;
  * Real memory usage increased from 80-110mb to 150-200mb.

# Osprey
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
cd ..
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
Time taken for tests:   55.972 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      12400000 bytes
HTML transferred:       2050000 bytes
Requests per second:    893.31 [#/sec] (mean)
Time per request:       11.194 [ms] (mean)
Time per request:       1.119 [ms] (mean, across all concurrent requests)
Transfer rate:          216.35 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       1
Processing:     6   11   3.4      9      52
Waiting:        3    9   3.0      8      48
Total:          6   11   3.5      9      52

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     11
  75%     12
  80%     14
  90%     17
  95%     18
  98%     19
  99%     20
 100%     52 (longest request)

```

### rework_webapi_parser
```
Document Path:          /songs?genre=foo&access_token=123
Document Length:        41 bytes

Concurrency Level:      10
Time taken for tests:   34.954 seconds
Complete requests:      50000
Failed requests:        0
Total transferred:      12400000 bytes
HTML transferred:       2050000 bytes
Requests per second:    1430.44 [#/sec] (mean)
Time per request:       6.991 [ms] (mean)
Time per request:       0.699 [ms] (mean, across all concurrent requests)
Transfer rate:          346.43 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.1      0       1
Processing:     4    7   1.7      6      54
Waiting:        2    5   1.5      5      37
Total:          4    7   1.7      6      54

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      7
  75%      7
  80%      7
  90%      9
  95%     10
  98%     12
  99%     13
 100%     54 (longest request)
```

## CPU and memory usage
### Setup
Installation:
```sh
sudo pip uninstall Pillow
sudo pip install psrecord matplotlib Pillowm
sudo apt-get install python-tk
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
