module Main where

import GI.Gtk.Declarative.App.Simple
import GI.Gtk.Declarative
import qualified GI.Gtk as Gtk
import qualified GI.Gdk as Gdk
import Pipes
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (forkIO)

import View.BuildGUI (buildGUI)
import EffectHandler.MakeTransitionFunction (setUpTransitionFunction)
import EffectHandler.HandleEffects (handleEffects)

import Model.InitializeState (initializeState, Configuration(..))
import Model.State
import Model.Action
import Model.Handler (handle)

main :: IO ()
main = do
  initialState' <- initializeState Configuration
  (makeTransition, asyncAction, cleanUp) <- setUpTransitionFunction
  let update' state action = makeTransition (handleEffects $ handle action) state
      producers = [let loop = (liftIO asyncAction >>= yield) *> loop in loop]

  Gtk.init Nothing
  screen <- maybe (fail "No screen?!") return =<< Gdk.screenGetDefault
  p      <- Gtk.cssProviderNew
  Gtk.cssProviderLoadFromData p styles
  Gtk.styleContextAddProviderForScreen
    screen
    p
    (fromIntegral Gtk.STYLE_PROVIDER_PRIORITY_USER)

  -- Start main loop
  forkIO $ do
    runLoop $ App update' buildGUI producers initialState'
    Gtk.mainQuit
  Gtk.main
  -- TODO: Not exception safe !!
  cleanUp

styles = mconcat
  [ ".chess-field {color: grey}"
  , ".black-piece {color: black}"
  , ".white-piece {color: white}"
  , ".chess-field-selected {background-color: green}"
  ]
