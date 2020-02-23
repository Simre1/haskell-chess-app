module Model.Error where


data Error = Error ErrorInfo deriving (Show)

data ErrorInfo = UnknownError String deriving (Show)

-- data SuccessInfo = OK deriving (Show)
