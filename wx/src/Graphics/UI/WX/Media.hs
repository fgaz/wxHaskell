{-# OPTIONS -fglasgow-exts #-}
--------------------------------------------------------------------------------
{-| Module      :  Media
    Copyright   :  (c) Daan Leijen 2003
    License     :  wxWindows

    Maintainer  :  daan@cs.uu.nl
    Stability   :  provisional
    Portability :  portable

    Images, Sounds, and action!
-}
--------------------------------------------------------------------------------
module Graphics.UI.WX.Media
            ( -- * Sound
              sound, play, playLoop, playWait
              -- * Images
            , image, imageCreateFromFile, imageCreateFromPixels, imageGetPixels
            , imageCreateFromPixelArray, imageGetPixelArray
            
              -- * Bitmaps
            , bitmap, bitmapCreateFromFile, bitmapFromImage
            ) where

import System.IO.Unsafe( unsafePerformIO )
import Graphics.UI.WXCore 
import Graphics.UI.WX.Types( Var, varGet, varSet, varCreate )
import Graphics.UI.WX.Attributes
import Graphics.UI.WX.Classes

{--------------------------------------------------------------------
  Bitmaps
--------------------------------------------------------------------}
-- | Return a managed bitmap object. Bitmaps are abstract images used
-- for drawing to a device context. The file path should point to
-- a valid bitmap file, normally a @.ico@, @.bmp@, @.xpm@, or @.png@,
-- but any file format supported by |Image| is correctly loaded.
--
-- Instances: 'Sized'.
bitmap :: FilePath -> Bitmap ()
bitmap fname
  = unsafePerformIO $ bitmapCreateFromFile fname

instance Sized (Bitmap a) where
  size  = newAttr "size" bitmapGetSize bitmapSetSize

-- | Create a bitmap from an image with the same color depth.
bitmapFromImage :: Image a -> IO (Bitmap ())
bitmapFromImage image
  = bitmapCreateFromImage image (-1)

{--------------------------------------------------------------------
  Images
--------------------------------------------------------------------}
-- | Return a managed image. Images are platform independent representations
-- of pictures, using an array of rgb pixels. See "Graphics.UI.WXCore.Image" for
-- lowlevel pixel manipulation. The file path should point to
-- a valid image file, like @.jpg@, @.bmp@, @.xpm@, or @.png@, for example.
--
-- Instances: 'Sized'.
image :: FilePath -> Image ()
image fname
  = unsafePerformIO $ imageCreateFromFile fname

instance Sized (Image a) where
  size  = newAttr "size" imageGetSize imageRescale

{--------------------------------------------------------------------
  Sounds
--------------------------------------------------------------------}
-- | Return a managed sound object. The file path points to 
-- a valid sound file, normally a @.wav@.
sound :: FilePath -> Wave ()
sound fname 
  = unsafePerformIO $ waveCreate fname False

-- | Play a sound fragment asynchronously.
play :: Wave a -> IO ()
play wave
  = unitIO (wavePlay wave True False)

-- | Play a sound fragment repeatedly (and asynchronously).
playLoop :: Wave a -> IO ()
playLoop wave
  = unitIO (wavePlay wave True True)

-- | Play a sound fragment synchronously (i.e. wait till completion).
playWait :: Wave a -> IO ()
playWait wave
  = unitIO (wavePlay wave False False)

