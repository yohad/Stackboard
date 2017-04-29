module Main where

import Reactive.Banana
import Reactive.Banana.Frameworks
import System.Clipboard
import Control.Exception
import Control.Concurrent

main :: IO ()
main = do
    sources <- (,) <$> newAddHandler <*> newAddHandler
    network <- setupNetwork sources
    actuate network
    s <- getClipboardString
    loop s sources

-- clipChange :: IO ()
clipChange epush = do
    s <- getClipboardString
    listen s epush
    where
        listen s ee= do
            c <- try getClipboardString :: IO (Either SomeException (Maybe String))
            case c of
                Left err -> listen s ee
                Right clip ->
                    if s /= clip then do
                        snd ee clip
                        listen clip ee
                    else
                        listen s ee

clipPop epop = do
    getLine >> snd epop Nothing
    clipPop epop

stackController :: Maybe String -> [String] -> [String]
stackController Nothing ls = safeTail ls
stackController (Just cs) ls = cs : ls

safeTail :: [a] -> [a]
safeTail [] = []
safeTail xs = tail xs

loop s (epop, epush) = do
    forkIO $ clipPop epop
    clipChange epush

setupNetwork (epop, epush) = compile $ do
    ePop <- fromAddHandler $ fst epop
    ePush <- fromAddHandler $ fst epush

    bStack <- accumB [] $ stackController <$> unionWith (++) ePush ePop
    eStack <- changes bStack

    reactimate' $ fmap print <$> eStack
