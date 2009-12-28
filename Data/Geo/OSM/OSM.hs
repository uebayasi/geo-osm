-- | The @osm@ element of a OSM file, which is the root element.
module Data.Geo.OSM.OSM(
                    OSM,
                    osm
                  ) where

import Text.XML.HXT.Arrow
import Text.XML.HXT.Extras
import Data.Geo.OSM.NodeWayRelation
import Data.Geo.OSM.Bound
import Data.Geo.OSM.Bounds
import Data.Geo.OSM.Accessor.Version
import Data.Geo.OSM.Accessor.Generator
import Data.Geo.OSM.Accessor.BoundOrs
import Data.Geo.OSM.Accessor.NodeWayRelations

-- | The @osm@ element of a OSM file, which is the root element.
data OSM = OSM String (Maybe String) (Maybe (Either Bound Bounds)) [NodeWayRelation]
  deriving Eq

instance XmlPickler OSM where
  xpickle = xpElem "osm" (xpWrap (\(version', generator', bound', nwr') -> OSM version' generator' bound' nwr', \(OSM version' generator' bound' nwr') -> (version', generator', bound', nwr'))
              (xp4Tuple (xpAttr "version" xpText)
                        (xpOption (xpAttr "generator" xpText))
                        (xpOption (xpAlt (either (const 0) (const 1)) [xpWrap (Left, \(Left b) -> b) xpickle, xpWrap (Right, \(Right b) -> b) xpickle]))
                        (xpList1 xpickle)))

instance Show OSM where
  show = showPickled []

instance Version OSM where
  version (OSM x _ _ _) = x

instance Generator OSM where
  generator (OSM _ x _ _) = x

instance BoundOrs OSM where
  boundOrs (OSM _ _ x _) n b bs = case x of Nothing -> n
                                            Just (Left b') -> b b'
                                            Just (Right b') -> bs b'

instance NodeWayRelations OSM where
  nwrs (OSM _ _ _ x) = x

-- | Constructs a osm with a version, bound or bounds, and node attributes and way or relation elements.
osm :: String -- ^ The @version@ attribute.
       -> Maybe String -- ^ The @generator@ attribute.
       -> Maybe (Either Bound Bounds) -- ^ The @bound@ or @bounds@ elements.
       -> [NodeWayRelation] -- ^ The @node@, @way@ or @relation@ elements.
       -> OSM
osm = OSM