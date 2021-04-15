# About

https://mtm.masterthemainframe.com

## CBL1

### Submit job

zowe jobs sub ds --vasc 'z10500.jcl(topaccts)'

### Get Files

```
zowe files dl ds 'z10500.source(topaccts)' -f topaccts.cbl
zowe files dl ds 'z10500.jcl(topaccts)' -f topaccts.jcl
zowe files dl ds 'z10500.output(topaccts)' -b -f topaccts.output
zowe files dl ds 'z10500.output(topaccts)' -f topaccts.output.txt
zowe files dl ds 'mtm2020.public.input(custrecs)' -b -f custrecs
zowe files dl ds 'mtm2020.public.input(custrecs)' -f custrecs.txt
```
