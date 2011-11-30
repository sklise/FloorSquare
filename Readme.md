# Floorsquare

Installation
------------
_Directions for local development._

1. Have Ruby.
2. Install Sinatra

        $ sudo gem install sinatra

3. Install Bundler

        $ sudo gem install bundler

4. Clone this repo and `cd` to the app.

        $ git clone git@github.com:stevenklise/FloorSquare.git
        $ cd FloorSquare

5. Bundle the gems, ignoring production database gems

        $ bundle --without production

6. Set up database

        $ irb
        > require './application'
        > DataMapper.auto_migrate! # This will erase the current contents of the db
        > DataMapper.auto_upgrade! # For adding updates, wont erase the db
    TODO: Make this a rake task.

API Routes
----------
**Here we define the routes used by Apps and Devices to create and read to and from Floorsquare.**

- Host: http://www.itpirl.com
- IP: 75.101.163.44
- Port: 80

### Swipes
**GET and POST methods for swipe events**

* POST '/swipes/new'

    **Params**:

    Required:

    - user_nnumber=99999999 (no N)
    - device_id=INTEGER
    - app_key=UNIQUE_SECRET_KEY

    Optional:

    - netid=STRING
    - credential=STRING (other reading from device)
    - extra=JSON (big json field for additional info)

* GET '/swipes'

    **Params**:

    Required:

    - app_key=UNIQUE_SECRET_KEY

    Optional:

    - until=YYYY-MM-DD
    - since=YYYY-MM-DD
    - device_id=INTEGER

* POST '/swipes/ID'

    ID=INTEGER
    
    **Params:**
    
    Required:
    
    - app_key=UNIQUE_SECRET_KEY
    
    Optional:
    
    - extra=JSON

### Members
**GET and POST methods for member information.**

A Member as defined here is a User that has a Swipe registered to the App.

* GET '/members/NNUMBER'

    Returns a json list of all Members who belong to the App.

    NNUMBER = valid n number, all integers, no leading N.
    
    **Params**:
    
    Required:
    
    - app_key=UNIQUE_SECRETE_KEY

* GET '/members/NNUMBER/swipes'

    Returns all swipes belonging to the specified member for the App.

    NNUMBER = valid n number, all integers, no leading N.
    
    **Params**:
    
    Required:
    
    - app_key=UNIQUE_SECRETE_KEY

MODELS
----------

### Swipe

* id => Serial # identifier used and set by database.
* timestamp => Date # If not set by the device, set by current server time.
* device_id => Integer # REQUIRED Identifies which device the swipe occurred.
* credential => String # THIS OR NETID REQUIRED Raw data from device.
* netid => String # THIS OR CREDENTIAL REQUIRED netid provided by device.
* app_id => CSV # List, or single value for apps to associated with this swipe.

### User

* id => Serial # identifier used and set by database.
* netid => String # 
* ? What else do we need for this model?

### App

* id => Serial # identifier used and set by database.
* auth_key => SHA # Unique id to identify app in API calls
* email => String # email for contact person of app.
* url => String # URL for app. To be used if we accomplish Push notifications
* push_on => Boolean # set to true if app desires push notifications. This is a wishlist feature.

### Device

* id => Serial # identifier used and set by database.
* auth_key => SHA # Unique id to identify device in POST requests.
* device_type_id => Integer # what kind of device is this?
* location => String or Integer # Identifies physical location of this device.

### Device_Types

* id => Serial # identifier used and set by database.
* name => String # name of device type
