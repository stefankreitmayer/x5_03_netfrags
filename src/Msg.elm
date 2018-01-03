module Msg exposing (..)

import Window
import Time exposing (Time)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)


type Msg
  = ChangeSearchString String
  | InspectItem Resource
  | CloseItemInspector
  | ToggleItemDropmenu Resource
  | ToggleItemOptional Resource Bool
  | DislikeItem Resource
  | UndoDislikeItem Resource
  | SelectReasonForHidingItem String
  | HoverRating (Rateable, Int)
  | UnHoverRating
  | EnterRating
  | UpdateWindowSize Window.Size
  | MarkItemAsStarted Resource
  | MarkItemAsCompleted Resource
  | ChangePageIndex String Int
  | Tick Time
  | UnimplementedAction


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  [ Window.resizes UpdateWindowSize
  , Time.every (100 * Time.millisecond) Tick
  ] |> Sub.batch
