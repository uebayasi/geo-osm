-- | The @area@ element of a OSM file.
module Data.Geo.OSM.Area where

import Text.XML.HXT.Arrow
import Text.XML.HXT.Extras
import Data.Geo.OSM.Accessor.Maximum

-- | The @area@ element of a OSM file.
newtype Area = Area String
  deriving Eq

-- | Constructs a @area@ with maximum.
area :: String -> Area
area = Area

instance XmlPickler Area where
  xpickle = xpElem "area" (xpWrap (area, \(Area r) -> r) (xpAttr "maximum" xpText))

instance Show Area where
  show = showPickled []

instance Maximum Area where
  maximum (Area x) = x
  setMaximum a (Area _) = area a