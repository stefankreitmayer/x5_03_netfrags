module Model.Resource exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)

type alias Resource =
  { mediaType : String
  , title : String
  , url : String
  , coverImageStub : String
  , date : String
  , tags : Set String
  , features : Dict String String
  , workload : Float }


workloadDisplayText hours =
  let
      minutes = hours * 60
  in
      if minutes < 20 then
        (minutes |> ceiling |> toString) ++ "min"
      else if minutes < 30 then
        ((minutes / 5 |> ceiling) * 5 |> toString) ++ "min"
      else if minutes < 50 then
        ((minutes / 10 |> ceiling) * 10 |> toString) ++ "min"
      else if minutes < 75 then
        "1h"
      else if minutes < 105 then
        "1.5h"
      else
        (hours |> round |> toString) ++ "h"


isItemOptional model resource =
  model.optionalItems |> Set.member resource.url


attrTextWorkload =
  "Workload (hours)"
