# Final Project Sketch

To save a new swipe to the database, each device must first register with whoever is in charge of the API to get a device auth_key. The url for the POST request will be of the form: 
@@http://itp.nyu.edu/floorsquare/DEVICE_KEY/@@

!!! GET from database for App

@@http://itp.nyu.edu/floorsquare/APP_KEY/user/NETID@@
@@http://itp.nyu.edu/floorsquare/APP_KEY/user/NETID@@

MODELS
==========

Swipe
----------
* id => Serial # identifier used and set by database.
* timestamp => Date # If not set by the device, set by current server time.
* device_id => Integer # REQUIRED Identifies which device the swipe occurred.
* credential => String # THIS OR NETID REQUIRED Raw data from device.
* netid => String # THIS OR CREDENTIAL REQUIRED netid provided by device.
* app_id => CSV # List, or single value for apps to associated with this swipe.

User
-----------
* id => Serial # identifier used and set by database.
* netid => String # 
* ? What else do we need for this model?

App
-----------
* id => Serial # identifier used and set by database.
* auth_key => SHA # Unique id to identify app in API calls
* email => String # email for contact person of app.
* url => String # URL for app. To be used if we accomplish Push notifications
* push_on => Boolean # set to true if app desires push notifications. This is a wishlist feature.

Device
-----------
* id => Serial # identifier used and set by database.
* auth_key => SHA # Unique id to identify device in POST requests.
* device_type_id => Integer # what kind of device is this?
* location => String or Integer # Identifies physical location of this device.

Device_Types
-----------
* id => Serial # identifier used and set by database.
* name => String # name of device type