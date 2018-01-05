module Util exposing (..)

capitalize : String -> String
capitalize str =
  (String.left 1 str |> String.toUpper) ++ (String.dropLeft 1 str)
