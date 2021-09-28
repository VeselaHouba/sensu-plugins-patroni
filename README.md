# Sensu Patroni Plugin
<!--- TOC
docker run --rm -v $(pwd)/README.md:/opt/README.md evkalinin/gh-md-toc:0.7.0 /opt/README.md
--->

<!-- TODO
[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-http)
[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-http.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-http)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-http.svg)](http://badge.fury.io/rb/sensu-plugins-http)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-http.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-http)
-->

* [Sensu Patroni Plugin](#sensu-patroni-plugin)
   * [Overview](#overview)
      * [Files](#files)
* [Usage examples](#usage-examples)


### Overview

This plugin provides basic monitoring of Patroni cluster through [Patroni REST API](https://patroni.readthedocs.io/en/latest/rest_api.html)

The Sensu assets packaged from this repository are built against the Sensu ruby runtime environment. When using these assets as part of a Sensu Go resource (check, mutator or handler), make sure you include the corresponding Sensu ruby runtime asset in the list of assets needed by the resource.  The current ruby-runtime assets can be found [here](https://bonsai.sensu.io/assets/sensu/sensu-ruby-runtime) in the [Bonsai Asset Index](bonsai.sensu.io)

#### Files
 * bin/check-patroni-cluster.rb

## Usage examples

**check-patroni-cluster.rb**
```
Usage: check-patroni-cluster.rb (options)
    -h <host>         Your patroni host (default "localhost")
    -p port           Your patroni API port (default 8008)
    --lag-warn num    Warning threshold for replication lag in bytes (default 1024)
    --lag-crit num    Critical threshold for replication lag in bytes (default 10240)
    -t secs           Timeout waiting for API to answer
```
