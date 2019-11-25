![CSIRO's Data61 Logo](https://raw.githubusercontent.com/qfpl/assets/master/data61-transparent-bg.png)

[![Build Status](https://travis-ci.org/qfpl/servant-waargonaut.svg?branch=master)](https://travis-ci.org/qfpl/servant-waargonaut)

# Servant integration for Waargonaut

This package allows you to use [waargonaut](https://github.com/qfpl/waargonaut)
for your [Servant API](https://hackage.haskell.org/package/servant). Where you
use would `JSON` in your API type, instead use `WaargJSON t`. Where `t` is the
type you're using the tag your Waargonaut `JsonEncode`/`JsonDecode` typeclasses.
Since Servant does not provide a nice way to pass in our encoders or decoders as
values. 

```
>>> -- GET /hello/world
>>> -- returning a JSON encoded World value
>>> data MyTag = MyTag
>>> type MyApi = "hello" :> "world" :> Get '[WaargJSON MyTag] World
```

Although the design of waargonaut does not encourage the use of typeclasses for
encoding/decoding JSON. We still have `Generic` functions, `JsonEncode`, and
`JsonDecode` typeclasses to allow this sort of integration.
