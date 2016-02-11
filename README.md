Touch Events
============

A jQuery plugin to expose convenient touch events.

This plugin sends events to the **touched** element using jQuery's normal event
bubbling mechanism, therefore allowing you to attach an event handler on a
parent element, use selectors, etc.


Usage
-----

Include jQuery or any library which is compatible with jQuery's event handling
mechanism, then include the touch.js file.

```litcoffee
$("#my-element").Touch()
$("#my-element").on "tap", (e) -> ...
$("#my-element").on "longtap", (e) -> ...
```

```litcoffee
$(document.body).Touch()
$("#my-element").on "tap", (e) -> ...
$("#my-parent").on "longtap", ".something", (e) -> ...
```


Events
------

The original event object (from the browser) is sent along with the following
events.

- tap
- longtap


Config
------

```javascript
{
    tapThreshold: 20, // tap event is discarded if finger moves by this amount
        // or more in X __OR__ Y direction!
    longtapDuration: 200, // event is considered a long tap if the tap lasts
        // this duration or more.
}
```


How Events are Identified
-------------------------

```
+-------------------------+
| User touches an element |
+-------------------------+
             |
             |                 Yes   +------------------------------+
 Did finger move more than   ------> | Event is discarded silently. |
  <TAP_THRESHOLD> amount?            +------------------------------+
             |
             | No
             V
 Has user's finger remained    Yes   +-------------------------------+
 on the element for at least ------> | "longtap" event is triggered. |
 <LONGTAP_DURATION>?                 +-------------------------------+
             |
             | No
             V
+-------------------------+
| User lifts his finger   |
| from the element.       |
+-------------------------+
             |
             |                 Yes   +------------------------------+
 Has "longtap" event already ------> | Event is discarded silently. |
 fired?                              +------------------------------+
             |
             | No
             V
+-------------------------+
| "tap" event is          |
| triggered.              |
+-------------------------+
```
