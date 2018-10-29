{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
module Servant.API.ContentTypes.Waargonaut ( WaargJSON ) where

import           Control.Applicative        ((<*))
import           Control.Category           ((.))
import           Control.Lens               (over, _Left)

import           Prelude                    (String, show, unlines)

import qualified Data.ByteString.Lazy       as BSL
import qualified Data.Text                  as Text

import           Data.Either                (Either)
import           Data.Function              (($))
import           Data.Typeable              (Typeable)

import qualified Data.List.NonEmpty         as NE
import qualified Network.HTTP.Media         as M

import           Data.Attoparsec.ByteString (eitherResult, endOfInput, parse)


import           Servant.API.ContentTypes   (Accept (..), MimeRender (..),
                                             MimeUnrender (..))

import           Waargonaut                 (parseWaargonaut)
import           Waargonaut.Decode          (ppCursorHistory, simpleDecode)
import           Waargonaut.Decode.Error    (DecodeError (ParseFailed))

import           Waargonaut.Encode          (simplePureEncodeNoSpaces)

import           Waargonaut.Generic         (JsonDecode, JsonEncode, mkDecoder,
                                             mkEncoder)

data WaargJSON deriving Typeable

instance Accept WaargJSON where
  contentTypes _ = "application" M.// "json" M./: ("charset", "utf-8") NE.:| [ "application" M.// "json" ]

instance JsonDecode a => MimeUnrender WaargJSON a where
  mimeUnrender _ = over _Left handleErr . simpleDecode mkDecoder parser . BSL.toStrict
    where
      parser =
        over _Left (ParseFailed . Text.pack)
        . eitherResult
        . parse (parseWaargonaut <* endOfInput)

      handleErr (dErr, hist) = unlines
        [ show dErr
        , show $ ppCursorHistory hist
        ]

instance JsonEncode a => MimeRender WaargJSON a where
  mimeRender _ = simplePureEncodeNoSpaces mkEncoder
