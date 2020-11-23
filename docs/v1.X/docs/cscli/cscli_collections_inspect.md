## cscli collections inspect

Inspect given collection

### Synopsis

Inspect given collection

```
cscli collections inspect collection [flags]
```

### Examples

```
cscli collections inspect crowdsec/xxx crowdsec/xyz
```

### Options

```
  -h, --help         help for inspect
  -u, --url string   Prometheus url (default "http://127.0.0.1:6060/metrics")
```

### Options inherited from parent commands

```
  -b, --branch string   Use given branch from hub
  -c, --config string   path to crowdsec config file (default "/etc/crowdsec/config.yaml")
      --debug           Set logging to debug.
      --error           Set logging to error.
      --info            Set logging to info.
  -o, --output string   Output format : human, json, raw.
      --trace           Set logging to trace.
      --warning         Set logging to warning.
```

### SEE ALSO

* [cscli collections](cscli_collections.md)	 - Manage collections from hub

