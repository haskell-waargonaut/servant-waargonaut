{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
module Servant.API.ContentTypes.Waargonaut ( WaargJSON ) where

import           Control.Applicative             ((<*))
import           Control.Category                ((.))
import           Control.Lens                    (over, _Left)

import           Prelude                         (show, unlines)

import           Data.Function                   (($))
import           Data.Typeable                   (Typeable)
import qualified Network.HTTP.Media              as M
import qualified Data.List.NonEmpty as NE

import           Data.Attoparsec.ByteString.Lazy (eitherResult, endOfInput,
                                                  parse)


import           Servant.API.ContentTypes        (Accept (..), MimeRender (..),
                                                  MimeUnrender (..))

import           Waargonaut                      (parseWaargonaut)
import           Waargonaut.Decode               (Err (..), ppCursorHistory,
                                                  simpleDecode, unCursorHist)
import           Waargonaut.Encode               (runPureEncoder)

import           Waargonaut.Generic              (JsonDecode, JsonEncode,
                                                  mkDecoder, mkEncoder)

data WaargJSON deriving Typeable

instance Accept WaargJSON where
  contentTypes _ = "application" M.// "json" M./: ("charset", "utf-8") NE.:| [ "application" M.// "json" ]

instance JsonDecode a => MimeUnrender WaargJSON a where
  mimeUnrender _ = over _Left handleErr . simpleDecode parser mkDecoder
    where
      parser = eitherResult . parse (parseWaargonaut <* endOfInput)

      handleErr (Parse e)             = e
      handleErr (Decode (dErr, hist)) = unlines
        [ show dErr
        , show $ ppCursorHistory hist
        ]

instance JsonEncode a => MimeRender WaargJSON a where
  mimeRender _ = runPureEncoder mkEncoder
