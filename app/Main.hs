module Main where

import Reactive.Banana
import Reactive.Banana.Frameworks
import System.Clipboard
import Data.Maybe(fromJust)
import Control.Exception

main :: IO ()
main = do
    sources <- (,) <$> newAddHandler <*> newAddHandler
    network <- setupNetwork sources
    actuate network
    s <- getClipboardString
    loop s sources

loop s (epop, epush) = do
    c <- try getClipboardString :: IO (Either SomeException (Maybe String))
    case c of
        Left err -> loop s (epop, epush)
        Right clip ->
            if s /= clip then do
                snd epush [fromJust clip]
                loop clip (epop, epush)
            else
                loop s (epop, epush)

setupNetwork (epop, epush) = compile $ do
    ePop <- fromAddHandler $ fst epop
    ePush <- fromAddHandler $ fst epush

    bStack <- accumB [""] $ (++) <$> ePush
    eStack <- changes bStack

    reactimate' $ fmap print <$> eStack
