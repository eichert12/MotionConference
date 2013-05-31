MotionConference
================

A rubymotion version of the ShowKit SDK Conference demo.

https://github.com/showkit/conference

STEPS TO RUN:
  1. Sign up for ShowKit (http://www.showkit.com/invites/new)
  2. Create 2 test users for the demo at http://www.showkit.com/subscribers
  3. cp resources/users.json.sample resources/users.json
  4. Edit resources/users.json to be set to your 2 test users created in step 2.  Note: ShowKit will generate usernames for you that will be different then those entered into the form and the generated subscribers may take a minute to appear in your subscribers list.
  5. rake device (since this needs your camera it needs to be run on the device.

Warnings:
  * I didn't spend any time on the layout and it doesn't work if you rotate your device (ie: its just as ugly as the ShowKit Objective C demo and doesn't handle rotation)

