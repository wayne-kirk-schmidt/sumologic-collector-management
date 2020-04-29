
Bash API Tools
==============

This is a collection of DevOps tools that serve as a wrapper for the Sumo Logic API.

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
    
    4. Clone this repo using the following command:
    
       git clone git@github.com:wks-sumo-logic/sumocli-bash.git

       This will create a new folder sumocli-bash
    
    5. Change into the this folder. 

       cd sumocli-bash/bin

Script Names and Purposes
=========================

```bash
├── clone
│   └── clone_collector 		-- clone a specific collector to a new name
├── create
│   ├── create_collector		-- create a hosted collector
│   └── create_source			-- create a web endpoint based data-source
├── delete
│   └── delete_collector		-- delete a collector based on unique id
├── list
│   ├── list_collector			-- list all collectors that exist within a specific organization
│   └── list_item			-- list all sources that are associated with a given collector and organization
└── query
```




General Usage
=============

To Do List:
===========

* extend to more Sumo Logic Items

* have list_collector become list_items for all Suo Logic Items

License
=======

Copyright 2020 Wayne Kirk Schmidt

Licensed under the GNU GPL License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    license-name   GNU GPL
    license-url    http://www.gnu.org/licenses/gpl.html

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Support
=======

Feel free to e-mail me with issues to: wschmidt@sumologic.com
I will provide "best effort" fixes and extend the scripts.

