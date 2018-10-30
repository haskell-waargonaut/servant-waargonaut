{-# LANGUAGE OverloadedStrings #-}
module Main (main, app') where

import           Data.String              (fromString)

import           Data.Proxy               (Proxy (..))

import qualified Control.Concurrent       as C

import           Control.Monad            (void)

import           Control.Exception        (bracket)
import           Control.Monad.IO.Class   (liftIO)

import qualified Data.ByteString.Char8    as BS8
import           Network.HTTP.Types       (methodPost)
import qualified Network.Wai.Handler.Warp as Warp
import qualified Network.Wai.Test         as WT

import qualified Waargonaut.Encode        as W
import qualified Waargonaut.Generic       as W

import           Test.Hspec               (describe, hspec, it)
import           Test.Hspec.Wai           (ResponseMatcher (..), get, post,
                                           request, shouldRespondWith, with,
                                           (<:>))

import           TestAPI                  (Person, TestAARG, app, testPerson,
                                           testPersonBS)

app' :: IO ()
app' = Warp.run 8888 app

main :: IO ()
main = hspec . with (pure app) $ do
  describe "/GET Encodes" $
    it "Responds with 200 and Contains a Waarg Encoded Person" $
      get "/" `shouldRespondWith` 200 { matchBody = fromString (BS8.unpack testPersonBS) }

  describe "/POST Decodes" $
    it "Responds with 200 and Accepts a Waarg Decoded Person" $
      let
        bdy =
          W.simplePureEncodeNoSpaces (W.proxy W.mkEncoder (Proxy :: Proxy TestAARG)) testPerson

        postRq =
          request methodPost "/" [("Content-Type", "application/json")] bdy
      in
        postRq `shouldRespondWith` "OMG" { matchStatus = 200 }

