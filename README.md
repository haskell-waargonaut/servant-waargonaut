Servant integration for Waargonaut
============================================

This package allows you to use [waargonaut](https://github.com/qfpl/waargonaut) for your [Servant API](https://hackage.haskell.org/package/servant). Where you use would `JSON` in your API type, instead use `WaargJSON`.

```
>>> -- GET /hello/world
>>> -- returning a JSON encoded World value
>>> type MyApi = "hello" :> "world" :> Get '[WaargJSON] World
```

Although the design of waargonaut does not encourage the use of typeclasses for encoding/decoding JSON. We still have `Generic` functions, `JsonEncode`, and `JsonDecode` typeclasses to allow this sort of integration.
