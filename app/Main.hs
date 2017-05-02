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

stackController :: Maybe String -> IO [String] -> IO [String]
stackController Nothing ls = do
    ss <- ls
    case safeHead ss of
        Nothing -> setClipboardString ""
        Just xs -> setClipboardString xs
    return $ safeTail ss
stackController (Just cs) ls = do
    ss <- ls
    return $ cs : ss

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:xs) = Just x

safeTail :: [a] -> [a]
safeTail [] = []
safeTail (x:xs) = xs

loop s (epop, epush) = do
    forkIO $ clipPop epop
    clipChange epush

ioList :: IO [a]
ioList = return []

ioPrint :: IO [String] -> IO ()
ioPrint ls = do
    ss <- ls
    print ss

setupNetwork (epop, epush) = compile $ do
    ePop <- fromAddHandler $ fst epop
    ePush <- fromAddHandler $ fst epush

    bStack <- accumB ioList $ stackController <$> unionWith const ePush ePop
    eStack <- changes bStack

    reactimate' $ fmap ioPrint <$> eStack
