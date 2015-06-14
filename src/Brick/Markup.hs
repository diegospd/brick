module Brick.Markup
  ( Markup
  , markup
  , (@?)
  )
where

import Control.Lens ((.~), (&))
import Control.Monad (forM)
import qualified Data.Text as T
import Data.Text.Markup
import Data.Default (def)

import Graphics.Vty (Attr, horizCat, string)

import Brick.Render
import Brick.AttrMap

class GetAttr a where
    getAttr :: a -> RenderM Attr

instance GetAttr Attr where
    getAttr = return

instance GetAttr AttrName where
    getAttr = lookupAttrName

(@?) :: T.Text -> AttrName -> Markup AttrName
(@?) = (@@)

markup :: (GetAttr a) => Markup a -> Render
markup m = do
    let pairs = toList m
    imgs <- forM pairs $ \(t, aSrc) -> do
        a <- getAttr aSrc
        return $ string a $ T.unpack t
    return $ def & image .~ horizCat imgs
