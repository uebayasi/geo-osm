-- | Values with a @nd@ accessor that is a list of @Nd@.
module Data.Geo.OSM.Accessor.Nds where

import Data.Geo.OSM.Nd
import Data.Geo.OSM.Accessor.Accessor

class Nds a where
  nds :: a -> [Nd]
  setNds :: [Nd] -> a -> a

  setNd :: Nd -> a -> a
  setNd = setNds . return

  usingNds :: ([Nd] -> [Nd]) -> a -> a
  usingNds = nds `using` setNds

  usingNd :: (Nd -> Nd) -> a -> a
  usingNd = usingNds . map