# Logstash plugin #

This is a [Logstash](https://github.com/elastic/logstash)-6.2.2 plugin to push data on Warp 10.

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

Logstash provides infrastructure to automatically generate documentation for this plugin. We use the asciidoc format to write documentation so any comments in the source code will be first converted into asciidoc and then into html. All plugin documentation are placed under one [central location](http://www.elastic.co/guide/en/logstash/current/).


* For formatting code or config example, you can use the asciidoc `[source,ruby]` directive

* For more asciidoc formatting tips, see the excellent reference here https://github.com/elastic/docs#asciidoc-guide

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Install
* To get started, clone the repository

* Compile

```
gem build logstash-output-warp10.gemspec
```

* Install plugin 

```
sudo bin/plugin install /path/to/logstash-output-warp10/logstash-output-warp10-0.1.0.gem
```

* Config Plugin, edit logstash.conf file

```
output {
  warp10 {
    warp_uri => "warp_uri"
    token => "token"
    gts_name => "log"
    labels => ['host']
    https => "false"
  }
}
```

* Run logstash

```
sudo bin/logstash -f logstash.conf
```

## Config File 

* warp_uri : required, indicate the url where to push data

* token : required, Write token allowing pushing on a Warp10 application

* gts_name : name of the gts wich will contain the logs, by default logstash

* labels : List of pattern, if they are contained in the event, then they are added to the gts as label, by default empty

* only_one_value : If true keep only one event key as value, otherwise the entire log is pushed as value, by default false

* value_key : The key of the value to push on Warp10 if onlyOneValue is true, by default message

* flush_size : This setting controls how many events will be buffered before sending a batch of events, by default 100

* idle_flush_time : The amount of time (in seconds) since last flush before a flush is forced, by default 1

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

## Contact

* contact@cityzendata.com
