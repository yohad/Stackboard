module Main where

import Reactive.Banana
import Reactive.Banana.Frameworks
import System.Clipboard
import Data.Maybe(fromJust)

main :: IO ()
main = do
    sources <- (,) <$> newAddHandler <*> newAddHandler
    network <- setupNetwork sources
    actuate network
    -- snd (snd sources) ["True"]
    -- snd (snd sources) ["True"]
    s <- getClipboardString
    loop s sources

-- loop :: String -> IO ()
loop s (epop, epush) = do
    c <- getClipboardString
    if s /= c then
        snd epush [fromJust c]
    else
        loop s (epop, epush)

-- setupNetwork :: (AddHandler Char, AddHandler String) ->
--                 IO EventNetwork
setupNetwork (epop, epush) = compile $ do
    ePop <- fromAddHandler $ fst epop
    ePush <- fromAddHandler $ fst epush

    bStack <- accumB [""] $ (++) <$> ePush
    eStack <- changes bStack

    reactimate' $ fmap print <$> eStack
