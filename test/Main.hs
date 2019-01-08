{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Data.Proxy              (Proxy (..))

import qualified Data.Text.Lazy.Encoding as TextLE

import qualified Data.ByteString.Lazy    as BSL
import           Network.HTTP.Types      (StdMethod (POST), status200)

import qualified Waargonaut.Encode       as W
import qualified Waargonaut.Generic      as W

import           TestAPI                 (TestAARG, app, testPerson,
                                          testPersonBS)

import           Test.Tasty              (defaultMain, testGroup)
import           Test.Tasty.Wai          (assertBody, assertStatus',
                                          buildRequestWithHeaders, get,
                                          srequest, testWai)

main :: IO ()
main = defaultMain $ testGroup "Servant Waargonaut"

  [ testWai app "GET '/' - 200 and contains a Waarg Encoded Person" $ do
      res <- get "/"
      assertBody (BSL.fromStrict testPersonBS) res

  , testWai app "POST '/' - 200 and accepts a Waarg Decoded Person" $ do
      let bdy = W.simplePureEncodeNoSpaces (W.proxy W.mkEncoder (Proxy :: Proxy TestAARG)) testPerson

      res <- srequest $ buildRequestWithHeaders POST "/"
             (TextLE.encodeUtf8 bdy)
             [("Content-Type", "application/json")]

      assertBody "OMG" res
      assertStatus' status200 res
  ]
