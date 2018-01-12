module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Time exposing (Time)
import Element.Input as Input

import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData


type alias Model =
  { ui : Ui
  , playlists : List Playlist
  , startedItems : List Resource
  , completedItems : List Resource
  , dislikedItems : List Resource
  , myNotesForItems : Dict String String
  , itemDropmenu : Maybe Resource
  , optionalItems : Set String
  , annotations : Dict (String, String) String
  , relevantTags : Set String
  , enteredRatings : Dict Rateable Int
  , hoveringRating : Maybe (Rateable, Int)
  , inspectedItem : Maybe Resource
  , inspectorMode : InspectorMode
  , windowWidth : Int
  , windowHeight : Int
  , paginationIndices : Dict String Int
  , infoPopup : Maybe String
  , currentTime : Time
  , timeOfLastPopupTrigger : Time
  , timeWhenSelectingReasonForDislikingItem : Time
  , errorMsg : Maybe String }


type alias Rateable =
  (String, String)


type alias Playlist =
  { heading : String
  , items : List Resource }


type InspectorMode
  = ShowItem
  | AskReasonForHidingItem
  | ThanksForReasonForHidingItem


initialModel : Model
initialModel =
  { ui = initialUi
  , playlists = Model.FakeData.exampleResources |> initialPlaylists
  , startedItems = Model.FakeData.fakeStartedItems
  , completedItems = []
  , dislikedItems = []
  , myNotesForItems = Dict.empty
  , itemDropmenu = Nothing
  , optionalItems = Set.empty
  , annotations = Dict.empty
  , relevantTags = Set.empty
  , enteredRatings = Dict.empty
  , hoveringRating = Nothing
  , inspectedItem = Nothing
  , inspectorMode = ShowItem
  , windowWidth = 1440 -- overwritten by initial Task
  , windowHeight = 900 -- overwritten by initial Task
  , paginationIndices = Dict.empty
  , infoPopup = Nothing
  , currentTime = 0 -- overwritten by subscription
  , timeOfLastPopupTrigger = -10000
  , timeWhenSelectingReasonForDislikingItem = -10000
  , errorMsg = Nothing }


initialPlaylists resources =
  [ generatePlaylistFromMediaType resources "Videos" "video"
  , generatePlaylistFromMediaType resources "Books" "book"
  , generatePlaylistFromMediaType resources "Podcasts" "podcast"
  , generatePlaylistFromMediaType resources "Podcast episodes" "podcast episode"
  , generatePlaylistFromMediaType resources "Courses" "course"
  , generatePlaylistFromMediaType resources "Articles" "article"
  , generatePlaylistFromMediaType resources "Meetups" "meetup group"
  , generatePlaylistFromMediaType resources "Presentations" "presentation"
  , generatePlaylistFromTags resources "Related to python" "python"
  ]


generatePlaylistFromTags items heading tag =
  Playlist heading (items |> List.filter (\item -> item.tags |> Set.member tag))


generatePlaylistFromMediaType items heading mediaType =
  Playlist heading (items |> List.filter (\item -> item.mediaType == mediaType))


getAnnotation model resource name =
  model.annotations |> Dict.get (resource.url, name) |> Maybe.withDefault ""


itemAnnotation =
  [ attrTextWorkload, "My Comments" ]


isItemStarted model resource =
  model.startedItems |> List.member resource


isItemCompleted model resource =
  model.completedItems |> List.member resource


modifyPlaylist : String -> List Resource -> List Playlist -> List Playlist
modifyPlaylist heading newItems playlists =
  playlists
  |> List.map (\playlist -> if playlist.heading == heading then { playlist | items = newItems } else playlist)


addToPlaylist : String -> Resource -> List Playlist -> List Playlist
addToPlaylist heading item playlists =
  playlists
  |> List.map (\playlist -> if playlist.heading == heading then { playlist | items = (item :: playlist.items) } else playlist)


removeFromList : a -> List a -> List a
removeFromList item xs =
  case xs of
    [] ->
      []

    (x :: xs) ->
      if x == item then
        removeFromList item xs
      else
        x :: (removeFromList item xs)


removeFromAllPlaylists : Resource -> List Playlist -> List Playlist
removeFromAllPlaylists item playlists =
  playlists
  |> List.map (\playlist -> { playlist | items = List.filter (\i -> i == item |> not) playlist.items })


popupVisible model =
  model.currentTime < model.timeOfLastPopupTrigger + 1500


excludeDislikedItems model items =
  items
  |> List.filter (\item -> model.dislikedItems |> List.member item |> not)


excludeItems itemsToExclude items =
  items
  |> List.filter (\item -> itemsToExclude |> List.member item |> not)


nItemsPerPage model =
  (model.windowWidth - 200) // 240 |> max 1

paginationIndex model heading =
  model.paginationIndices |> Dict.get heading |> Maybe.withDefault 0

headingStartedItems = "Continue learning"
headingNextItems = "Up next"
headingCompletedItems = "Well done! You have completed "


nextItems model =
  Model.FakeData.exampleResources
  |> excludeItems model.startedItems
  |> excludeItems model.completedItems
  |> List.drop ((List.length model.startedItems) * 5) -- mockup: arbitrary pick from unstarted/uncompleted
  |> List.drop ((List.length model.completedItems) * 5) -- mockup: arbitrary pick from unstarted/uncompleted
  |> List.take 3
