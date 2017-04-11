{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_Stackboard (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\bin"
libdir     = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\lib\\x86_64-windows-ghc-8.0.2\\Stackboard-0.1.0.0-3zCrkxrq8Ia3RB7wQ6UnaO"
dynlibdir  = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\lib\\x86_64-windows-ghc-8.0.2"
datadir    = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\share\\x86_64-windows-ghc-8.0.2\\Stackboard-0.1.0.0"
libexecdir = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\libexec"
sysconfdir = "D:\\Haskell\\Stackboard\\.stack-work\\install\\05480a1e\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Stackboard_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Stackboard_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Stackboard_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Stackboard_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Stackboard_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Stackboard_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
