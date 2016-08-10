module Domain.Project (Project(Project, projectIdentifier, projectName, projectShortName, projectDeadline)) where

import Import

share [mkPersist sqlSettings, mkMigrate "migrateProjects"] [persistLowerCase|
Project
  identifier Int
  name Text
  shortName Text
  deadline UTCTime
  deriving Show
|]