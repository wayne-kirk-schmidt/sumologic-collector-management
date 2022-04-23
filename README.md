
Bash API Tools
==============

This is a small set of tools that are a wrapper for the Sumo Logic API for collectors and sources

Installing the Scripts
=======================

The scripts are command line based, designed to be used within a batch script or DevOPs tool such as Chef or Ansible.
Written in bash, all scripts are listed below, and the dependencies are on a Unix/Linux tool set.

You will need to use Bash 4+ as some of the scripts use associative arrays in the scripts.

Please follow the following steps to install:

    1. Download and install jq and curl for your platform if you don't already have it installed.

       jq can be downloaded from https://stedolan.github.io/jq/download/

       curl can be downloaded from https://curl.haxx.se/download.html

    2. Download and install git for your platform if you don't already have it installed.

       It can be downloaded from https://git-scm.com/downloads
    
    3. Open a new shell/command prompt. Change to the folder where you want to install the scripts.
    
    4. Clone this repo
    
    5. Change into the local directory

Script Names and Purposes
=========================

```
bin
├── bash
│   ├── clone
│   │   └── clone_collector
│   ├── create
│   │   ├── create_collector
│   │   └── create_source
│   ├── delete
│   │   └── delete_collector
│   └── list
│       ├── list_collector
│       └── list_item
└── powershell
    └── update
        └── update_collector_config.ps1
```

Bash Script Usage
=================

1. To list the collectors you can issue:

   list_collector -a APIKEY:APISTRING -s jp

2. To create a hosted collector you can issue:

   create_collector -a APIKEY:APISTRING -s jp -n "sample-name-1"

NOTE: ths returns the ID of the created collector -- COLLECTORID

3. To create a web endpoint source for a given collector you can issue:

  create_source -a APIKEY:APISTRING -s jp -n "sample-source-2" -i COLLECTORID

NOTE: ths returns the ID of the created sourrce-- SOURCEID

4. To clone a given collector to a new collector name you can issue:

   clone_collector -a APIKEY:APISTRING -s jp -n "sample-name-444" -i COLLECTORID -d

5. To delete a specific collector you can issue:

   delete_collector -a APIKEY:APISTRING -s jp -i COLLECTORID

NOTE: this creates a backup file of the collector in /tmp

To Do List:
===========

* Build out powershell examples for the bash counterparts

License
=======

Copyright 2020 Wayne Kirk Schmidt
https://www.linkedin.com/in/waynekirkschmidt

Licensed under the Apache 2.0 License (the "License");

You may not use this file except in compliance with the License.
You may obtain a copy of the License at

    license-name   APACHE 2.0
    license-url    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Support
=======

Feel free to e-mail me with issues to: 

+    wschmidt@sumologic.com

+    wayne.kirk.schmidt@gmail.com

I will provide "best effort" fixes and extend the scripts.
