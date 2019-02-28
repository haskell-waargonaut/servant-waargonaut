{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
-- | Integrate Waargonaut with Servant, including support for the tagged typeclass encoder/decoder functionality.
module Servant.API.ContentTypes.Waargonaut ( WaargJSON ) where

import           Control.Category              ((.))

import           Prelude                       (show)

import           Data.Bifunctor                (first)
import           Data.Function                 (($))
import           Data.Proxy                    (Proxy (..))
import           Data.Typeable                 (Typeable)

import qualified Data.List.NonEmpty            as NE
import qualified Network.HTTP.Media            as M

import           Servant.API.ContentTypes      (Accept (..), MimeRender (..),
                                                MimeUnrender (..))

import qualified Data.ByteString.Lazy          as BL

import qualified Text.PrettyPrint.Annotated.WL as WL

import           Waargonaut.Attoparsec         (pureDecodeAttoparsecByteString)

import qualified Waargonaut.Decode             as D
import qualified Waargonaut.Encode             as E

import           Waargonaut.Generic            (JsonDecode, JsonEncode)
import qualified Waargonaut.Generic            as G

-- | Replacement for 'Servant.API.ContentTypes.JSON' that will use the relevant instances from
-- Waargonaut that are tagged with the type @t@.
--
-- This allows you to have separate typeclass implementations for the same type for different routes
-- and have it be evident in the types. Without the need for creating a 'newtype' for each one.
--
-- Where you would use 'JSON' to use 'aeson' for encoding or decoding, you use 'WaargJSON t', with
-- the @t@ denoting the tag type. Refer to the <https://hackage.haskell.org/package/waargonaut Waargonaut>
-- package for more information about why this is so.
--
-- A hello world example:
--
-- >>> -- GET /hello/world
-- >>> -- returning a JSON encoded World value
-- >>> data MyTag = MyTag
-- >>> type MyApi = "hello" :> "world" :> Get '[WaargJSON MyTag] World
--
data WaargJSON t
  deriving Typeable

instance Accept (WaargJSON t) where
  contentTypes _ = "application" M.// "json" M./: ("charset", "utf-8") NE.:| [ "application" M.// "json" ]

instance JsonDecode t a => MimeUnrender (WaargJSON t) a where
  mimeUnrender _ = first handleErr
    . pureDecodeAttoparsecByteString (G.proxy G.mkDecoder (Proxy :: Proxy t))
    . BL.toStrict
    where
      handleErr (dErr, hist) = WL.display . WL.renderPrettyDefault $
        WL.text (show dErr) WL.<##> D.ppCursorHistory hist

instance JsonEncode t a => MimeRender (WaargJSON t) a where
  mimeRender _ = E.simplePureEncodeByteStringNoSpaces (G.proxy G.mkEncoder (Proxy :: Proxy t))
