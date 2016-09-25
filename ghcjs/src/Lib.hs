{-# LANGUAGE DeriveGeneric #-}
module Lib ( setupClickHandlers ) where

import GHC.Generics
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BS (pack)

import Data.JSString hiding (last)

import GHCJS.DOM
import GHCJS.DOM (runWebGUI, webViewGetDomDocument)
import GHCJS.DOM.HTMLButtonElement (castToHTMLButtonElement, setValue)
import GHCJS.DOM.Document (getElementById)
import GHCJS.DOM.EventTarget
import GHCJS.DOM.EventTargetClosures
import GHCJS.DOM.Types

import JavaScript.Web.XMLHttpRequest
import JavaScript.Web.Location

data DeletionResponse = DeletionResponse { target :: String } deriving (Generic, Show)
instance ToJSON DeletionResponse where
  toEncoding = genericToEncoding defaultOptions
instance FromJSON DeletionResponse

setupClickHandlers :: IO ()
setupClickHandlers = do
  runWebGUI $ \webView -> do
    Just doc <- webViewGetDomDocument webView
    Just element <- getElementById doc "delete-project"
    button <- castToHTMLButtonElement element
    clickCallback <- eventListenerNew $ deleteProject
    addEventListener button "click" (Just clickCallback) False

makeRequest :: String -> Request
makeRequest projectId = Request {
  reqMethod = DELETE,
  reqURI = pack $ "/project/" ++ projectId,
  reqLogin = Nothing,
  reqHeaders = [],
  reqWithCredentials = False,
  reqData = NoData
}

requestProjectDeletion :: String -> IO (Response String)
requestProjectDeletion projectId = xhrString $ makeRequest projectId

deleteProject :: MouseEvent -> IO()
deleteProject _ = do
  currentLocation <- getWindowLocation
  currentHref <- getHref currentLocation
  response <- requestProjectDeletion $ unpack $ extractLastPiece currentHref
  redirect currentLocation currentHref response
  where
    redirect currentLocation oldHref resp = setHref (pack $ getTarget oldHref resp) currentLocation
    extractLastPiece href = last $ splitOn' (pack "/") href
    getTarget fallback resp = maybe (unpack fallback) target $ ((BS.pack `fmap` contents resp) >>= decode)
