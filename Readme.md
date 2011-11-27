#### DataMapper setup

1. `$ bundle`
2. Change `DataMapper.setup()` to your proper file path
3. Add properties to models just like in `app/models/user.rb`
4.
    $ irb
    > require './application'
    > DataMapper.auto_migrate! # This will erase the current contents of the db
    > DataMapper.auto_upgrade! # For adding updates, wont erase the db


# Final Project Sketch

To save a new swipe to the database, each device must first register with whoever is in charge of the API to get a device auth_key. 


ROUTES
==========

### API Routes
**Here we define the routes used by Apps and Devices to create and read to and from Floorsquare.**

##### POST Routes
**Expected behavoir for these routes is for a reading from a Device.**

- POST `/DEVICE_KEY/` The params of the post request will be defined later.

##### GET Routes
**Expected behavoir for these routes is for presentation and use of individual Apps.**

- GET `/APP_KEY/users/NETID`
- GET `/APP_KEY/users/`
- GET `/APP_KEY/date/20111127` 
- GET `/APP_KEY/`


### Admin Routes
**These routes will be used by the administrators of Floorsquare.**

- GET `/admin`
- GET `/admin/apps`
- GET & POST `/admin/apps/new`
- GET, PUT & DELETE `/admin/apps/ID`
- GET `/admin/apps/ID/edit`
- GET `/admin/devices`
- GET & POST `/admin/devices/new`
- GET, PUT & DELETE `/admin/devices/ID`
- GET `/admin/devices/ID/edit`


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
