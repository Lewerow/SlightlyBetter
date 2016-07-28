module Handler.Project where
import Import

import Database.Projects
import Yesod.Bootstrap()

getProjectR :: Int -> Handler Html
getProjectR projectId = defaultLayout $ do
  setTitle $ ("Project " ++ (createTitle projectId))
  $(widgetFile "project")
  where
    createTitle id = (toHtml id) ++ projectName
    projectName = toHtml $ maybe "<<Unknown>>" snd projectEntry
    projectEntry = find (\x -> (fst x) == projectId) projects