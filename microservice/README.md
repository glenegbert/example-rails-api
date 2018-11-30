## **Set Up**

Get started by cloning this repo and running

  `bundle`

  `rails s`

You can run tests using ```rspec``` in console or test manually by using an HTTP client such as https://httpie.org/.

## **Usage**

This API has 3 available endpoints with the parameters in the examples below(all parameters are required).  All dates should be in ISO 8601 format.


**POST /ads**

  ```
  Example Request
    {
      "creative": "<div>Ad Here</div>",
      "start_date": "2018-11-08",
      "end_date": "2018-11-10",
      "goal": 1000,
      "priority": 1,
      "zone_id": 3
    }
  ```

  ```
  Example Response
    {
      "created_at": "2018-11-30T14:19:08.804Z",
      "creative": "<div>Ad Here</div>",
      "start_date": "2018-08-11",
      "end_date": "2018-10-11",
      "goal": 1000,
      "id": 10,
      "priority": 1,
      "updated_at": "2018-11-30T14:19:08.804Z",
      "zone_id": 3
    }
    ```


**POST /zones** - creates a zone

   ```
   Example Request
     {
       "impressions": 1000,
       "title": "US/Mountain"
     }
    ```


   ```
   Example Response
     {
       "created_at": "2018-11-30T14:28:44.390Z",
       "id": 4,
       "impressions": 1000,
       "title": "US/Mountain",
       "updated_at": "2018-11-30T14:28:44.390Z"
     }
    ```

**POST /reports** - a list of ads for given zone with the fulfillment forecast for the given day


   ```
  Example Request
    {
      "date": "2018-01-08",
      "zone_id": 3
    }
   ```

   ```
  Example Response
    [
        {
            "ad_id": 9,
            "percentage": 10.0
        } ,
        {
            "ad_id": 20,
            "percentage": 75.0
        }
    ]
   ```


## **How We Calculate Ad Forecasts**

### **Determine the daily impression goal for each ad**

Assume we have an ad with a start date of 1/10/2018 and end date of 1/13/2018.  It has a TOTAL impressions goal of 1000.  To get the DAILY impression goal for the ad we take its total impression goal and divide it by the number of days the ad will run.  So in this case we would have 1000(total impressions) divided by 4(days the ad will run) for a daily impression goal of 250.


### **Determine the percentage of the daily impression goal which can be met for each ad on a given day**

Each ad is assigned a zone which has a limited number of impressions that can be assigned on any given day.  For this example let’s use Zone 4, which has a daily impression capacity of 2000.

In addition to daily impression goals, ads also have a priority assignment which we use to determine how the available impressions from a zone are distributed.  For this example lets assume we have the following ads which will all be running on the day we are forecasting for.

      Ad A - has priority of 2 and daily impression goal of 2000

      Ad B - has priority of 1 and daily impression goal of 500

      Ad C - has priority of 3 and daily impression goal of 1000

To start we have 2000 impressions available and we start by assigning impressions to the ad with the highest priority:

      Ad B - 100%(500) of 500 impressions will be fulfilled

This leaves 1500 impressions available. So we assign those to the next ad in line by priority.  However we don’t have enough impressions to meet that ad’s daily goal, so it gets a partial fulfillment.

     Ad A - 1500(75%) of 2000 impressions will be fulfilled

All available impressions for Zone 4 have now been used for this day, so the final zone will not be fulfilled at all.

    Ad C - 0(0%) of 1000 impressions will be fulfilled

