module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Element.Input as Input

import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData


type alias Model =
  { ui : Ui
  , playlists : List Playlist
  , expandedSearchResults : List String
  , itemDropmenu : Maybe Resource
  , optionalItems : Set String
  , annotations : Dict (String, String) String
  , relevantTags : Set String
  , dislikedResult : Maybe String
  , enteredRatings : Dict Rateable Int
  , hoveringRating : Maybe (Rateable, Int)
  , selectedItem : Maybe (Resource, Playlist)
  , windowWidth : Int
  , errorMsg : Maybe String }


type alias Rateable =
  (String, String)


type alias Playlist =
  { heading : String
  , items : List Resource }


initialModel : Model
initialModel =
  { ui = initialUi
  , playlists = Model.FakeData.exampleResources |> initialPlaylists
  , expandedSearchResults = []
  , itemDropmenu = Nothing
  , optionalItems = Set.empty
  , annotations = Dict.empty
  , relevantTags = Set.empty
  , dislikedResult = Nothing
  , enteredRatings = Dict.empty
  , hoveringRating = Nothing
  , selectedItem = Nothing
  , windowWidth = 1440 -- overwritten by initial Task
  , errorMsg = Nothing }


initialPlaylists resources =
  [ Playlist playlistHeadingStarted []
  , Playlist playlistHeadingCompleted []
  , generatePlaylistFromTag resources "Videos" "video"
  , generatePlaylistFromTag resources "Books" "book"
  , generatePlaylistFromTag resources "Podcasts" "podcast"
  , generatePlaylistFromTag resources "Courses" "course"
  , generatePlaylistFromTag resources "Articles" "article"
  , generatePlaylistFromTag resources "Meetups" "meetup group"
  , generatePlaylistFromTag resources "Presentations" "presentation"
  , generatePlaylistFromTag resources "Related to python" "python"
  ]


generatePlaylistFromTag resources heading tag =
  Playlist heading (resources |> List.filter (\resource -> resource.tags |> Set.member tag))


getAnnotation model resource name =
  model.annotations |> Dict.get (resource.url, name) |> Maybe.withDefault ""


itemAnnotation =
  [ attrTextWorkload, "My Comments" ]


playlistHeadingStarted = "Started (continue learning)"


playlistHeadingCompleted = "Done (congratulations)"


startedItems model =
  playlistHeadingStarted |> getPlaylistItems model


completedItems model =
  playlistHeadingCompleted |> getPlaylistItems model


isItemStarted model resource =
  startedItems model |> List.member resource


isItemCompleted model resource =
  completedItems model |> List.member resource


getPlaylistItems : Model -> String -> List Resource
getPlaylistItems model heading =
  let
      maybePlaylist =
        model.playlists |> List.filter (\playlist -> playlist.heading == heading) |> List.head
  in
      case maybePlaylist of
        Nothing ->
          []

        Just playlist ->
          playlist.items


modifyPlaylist : String -> List Resource -> List Playlist -> List Playlist
modifyPlaylist heading newItems playlists =
  playlists
  |> List.map (\playlist -> if playlist.heading == heading then { playlist | items = newItems } else playlist)


addToPlaylist : String -> Resource -> List Playlist -> List Playlist
addToPlaylist heading item playlists =
  playlists
  |> List.map (\playlist -> if playlist.heading == heading then { playlist | items = (item :: playlist.items) } else playlist)


-- removeFromPlaylist : String -> Resource -> List Playlist -> List Playlist
-- removeFromPlaylist heading item playlists =
--   playlists
--   |> List.map (\playlist -> if playlist.heading == heading then { playlist | items = List.filter (\i -> i == item |> not) playlist.items } else playlist)


removeFromAllPlaylists : Resource -> List Playlist -> List Playlist
removeFromAllPlaylists item playlists =
  playlists
  |> List.map (\playlist -> { playlist | items = List.filter (\i -> i == item |> not) playlist.items })
