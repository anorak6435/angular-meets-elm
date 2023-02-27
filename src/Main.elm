port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D

-- Main

main : Program () Model Msg
main =
    Browser.element
        {   init = init
        ,   view = view
        ,   update = update
        ,   subscriptions = subscriptions
        }

-- Ports

port sendMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg

-- Model

type alias Model = 
    { draft : String
    , messages : List String
    }

init : () -> (Model, Cmd Msg)
init flags =
    ( {draft = "", messages = []}
    , Cmd.none
    )

-- update

type Msg
    = DraftChanged String
    | Send
    | Recv String

-- use the send message port on ENTER or onclick send button

update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        DraftChanged draft ->
            ( {model | draft = draft}
            , Cmd.none
            )
        Send ->
            ( {model | draft = "" }
            , sendMessage model.draft
            )

        Recv message ->
            ( {model | messages = model.messages ++ [message]}
            , Cmd.none
            )

-- Subscriptions
-- subscribe to the message receiver

subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv

-- view
view : Model -> Html Msg
view model =
    div []
        [ h3 [] [text "Messages from Angular:"]
          , ul []
            (List.map (\msg -> li [] [text msg ]) model.messages)
          , input
            [ type_ "text"
            , placeholder "Type Text"
            , onInput DraftChanged
            , on "keydown" (ifIsEnter Send)
            , value model.draft
            ]
            []
          , button [ onClick Send ] [ text "Send to Angular" ]
        ]

-- Detect Enter

ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg
                else
                    D.fail "some other key"
            )