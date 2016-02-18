Copyright 2016 TJ Woon

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


Touch
=====

Implementation
--------------

    Touch = (elt, conf={}) ->

### Config

        TAP_THRESHOLD = conf.tapThreshold or 20
        LONGTAP_DURATION = conf.longtapDuration or 200


### State

        touches = {} # Touch.identifier => {
            #   longtapTimeoutId: timeout ID for longtap identification
            #   event: latest known native browser event
            #   startX, startY: starting x and y screen coordinates
            # }
            # Only holds touches which have not been identified (triggered) yet!


### Helpers

        addEventListener = (eventName, eventHandler, capture=false) ->
            if elt.addEventListener?
                elt.addEventListener eventName, eventHandler, capture
            else if elt.attachEvent?
                elt.attachEvent "on#{eventName}", eventHandler

        removeEventListener = (eventName, eventHandler, capture=false) ->
            if elt.removeEventListener?
                elt.removeEventListener eventName, eventHandler, capture
            else if elt.detachEvent?
                elt.detachEvent "on#{eventName}", eventHandler

        longtapTimer = (id) ->
            ->
                if (touch = touches[id])?
                    delete touches[id]
                    $(touch.event.target).trigger "longtap", touch.event

### Init

        addEventListener "touchstart", (evt) ->
            $.each evt.changedTouches, (i, touch) ->
                timeout = setTimeout longtapTimer(touch.identifier), LONGTAP_DURATION
                touches[touch.identifier] =
                    longtapTimeoutId: timeout
                    event: touch
                    startX: touch.clientX
                    startY: touch.clientY

        addEventListener "touchmove", (evt) ->
            $.each evt.changedTouches, (i, touch) ->
                t = touches[touch.identifier]
                if t?
                    t.event = touch
                    deltaX = Math.abs touch.clientX - t.startX
                    deltaY = Math.abs touch.clientY - t.startY
                    if deltaX >= TAP_THRESHOLD or deltaY >= TAP_THRESHOLD
                        delete touches[touch.identifier]

        addEventListener "touchend", (evt) ->
            $.each evt.changedTouches, (i, touch) ->
                t = touches[touch.identifier]
                if t?
                    clearTimeout t.longtapTimeoutId
                    delete touches[touch.identifier]
                    $(t.event.target).trigger "tap", touch

        addEventListener "touchcancel", (evt) ->
            $.each evt.changedTouches, (i, touch) ->
                t = touches[touch.identifier]
                if t?
                    clearTimeout t.longtapTimeoutId
                    delete touches[touch.identifier]

        undefined

    Touch.version = "1.0.1"


jQuery
------

    $.fn.Touch = (conf) ->
        @each ->
            t = $(this).data "Touch"
            unless t?
                t = new Touch this, conf
                $(this).data "Touch", t
            t

    $.Touch = Touch
