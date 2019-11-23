{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedLists   #-}

module Interface.View
  (view) where

import GI.Gtk.Declarative.App.Simple (AppView)
import GI.Gtk.Declarative (Attribute((:=)), widget, bin, container, on)
import GI.Gtk (Label(..), Window(..), ListBox(..), ListBoxRow(..), Button(..))
import Optics.Core ((^.))

import Interface.InterfaceState (InterfaceState, interfaceText)
import Interface.InterfaceEvent (InterfaceEvent(..))

view :: InterfaceState -> AppView Window InterfaceEvent
view state =
  bin
    Window
      [ (#title := "Hello")
    --  , on #deleteEvent (const (True, Closed))
      , (#widthRequest := 400)
      , (#heightRequest := 300)]
  $ container ListBox []
    [ bin ListBoxRow [] (widget Label [(#label := (state ^. interfaceText))] )
    , bin ListBoxRow [] (widget Button [on #clicked ForGlory])
    ]
