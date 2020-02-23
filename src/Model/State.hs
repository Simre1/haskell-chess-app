module Model.State where

import Optics.Core
import Optics.TH

import Data.Map
import Data.Time.Calendar

import Data.Text (Text)

import Game.Chess

data State = State
  { _gameTabs :: Map TabId (Tab GameTab)
  , _incrementId :: Int
  }

type TabId = Int

data Tab t = Tab
  { _tabName :: Text
  , _mainPanel :: Panel t
  , _sidePanels :: [Panel t]
  , _tabType :: TabType t
  }

data TabType t where
  GameTabS :: GameTab -> TabType GameTab


data Panel t where
  PanelText :: Allowed SPanelText x ~ True => Text -> Panel x
  ChessBoard :: Allowed SChessBoard x ~ True => Panel x

data SPanelText
data SChessBoard


data GameTab = GameTab
  { _selectedField :: Maybe (Int, Int)
  , _game :: Game
  }

data Game = Game
  { _position :: Position
  , _event :: Maybe Text
  , _date :: Maybe Day
  , _round :: Maybe Int
  , _whitePlayer :: Maybe Text
  , _blackPlayer :: Maybe Text
  , _resultInfo :: Result
  }

data Result = Undecided | Win Color | Draw


data True
data False

type family Allowed x c where
  Allowed SPanelText c = True
  Allowed SChessBoard GameTab = True
  Allowed x c = False

makeLenses ''State
makeLenses ''Tab
makeLenses ''Game
makeLenses ''GameTab

concreteTab :: Lens' (Tab t) t
concreteTab = tabType % lens (unpackType) (packType)
  where
    unpackType :: TabType t -> t
    unpackType (GameTabS t) = t
    packType :: TabType t -> t -> TabType t
    packType (GameTabS _) t = GameTabS t
