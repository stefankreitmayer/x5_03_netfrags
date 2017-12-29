module Main exposing (..)

import Html exposing (Html)
import Task
import Window

import Model exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)
import Msg exposing (Msg, subscriptions)

--------------------------------------------------------------------------- MAIN

main : Program Never Model Msg
main =
  Html.program
  { init = (initialModel, getWindowSize)
  , update = update
  , view = view
  , subscriptions = subscriptions }


getWindowSize : Cmd Msg
getWindowSize =
  Window.size |> Task.perform Msg.UpdateWindowSize
