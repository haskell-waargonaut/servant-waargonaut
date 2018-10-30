{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE StandaloneDeriving    #-}
{-# LANGUAGE TupleSections         #-}
{-# LANGUAGE TypeOperators         #-}
module TestAPI
  ( TestAPI
  , TestAARG
  , Person (..)
  , testPersonBS
  , testPerson
  , app
  ) where

import qualified GHC.Generics                        as GHC

import           Data.Bool                           (bool)
import           Data.Proxy                          (Proxy (..))
import           Servant.API                         ((:<|>) ((:<|>)), (:>),
                                                      Get, PlainText, Post,
                                                      ReqBody)
import           Servant.Server                      (Server, serve)

import           Network.Wai                         (Application)

import           Data.ByteString                     (ByteString)
import qualified Data.Char                           as Char
import qualified Data.List                           as List
import           Data.Maybe                          (fromMaybe)
import           Data.Text                           (Text)
import qualified Data.Text                           as Text

import           Waargonaut.Generic                  (Generic,
                                                      HasDatatypeInfo,
                                                      JsonDecode (..),
                                                      JsonEncode (..),
                                                      Options (..), defaultOpts,
                                                      gDecoder, gEncoder)

import           Debug.Trace                         (traceShowId)
import           Servant.API.ContentTypes.Waargonaut (WaargJSON)

data TestAARG = TestAARG

data Person = Person
  { _personName                    :: Text
  , _personAge                     :: Int
  , _personAddress                 :: Text
  , _personFavouriteLotteryNumbers :: [Int]
  }
  deriving (Eq, Show, GHC.Generic)

instance HasDatatypeInfo Person
instance Generic Person

personWaargOpts :: Options
personWaargOpts = defaultOpts
  { _optionsFieldName =
      (\n ->
         maybe n (\(h',t') -> Text.unpack $ Text.cons (Char.toLower h') t')
         $ Text.uncons
         =<< Text.stripPrefix "_person" (Text.pack n)
      )
  }

instance JsonEncode TestAARG Person where mkEncoder = gEncoder personWaargOpts
instance JsonDecode TestAARG Person where mkDecoder = gDecoder personWaargOpts

testPersonBS :: ByteString
testPersonBS = "{\"name\":\"Krag\",\"age\":88,\"address\":\"Red House 4, Three Neck Lane, Greentown.\",\"favouriteLotteryNumbers\":[86,3,32,42,73]}"

testPerson :: Person
testPerson = Person "Krag" 88 "Red House 4, Three Neck Lane, Greentown." [86,3,32,42,73]

type TestAPI =
  {- | Test Encoding -} Get '[WaargJSON TestAARG] Person :<|>
  {- | Test Decoding -} ReqBody '[WaargJSON TestAARG] Person :> Post '[PlainText] Text

simpleApi :: Proxy TestAPI
simpleApi = Proxy

server :: Server TestAPI
server =
  pure testPerson :<|>
  pure . bool "NOOO" "OMG" . (== testPerson)

app :: Application
app = serve simpleApi server
