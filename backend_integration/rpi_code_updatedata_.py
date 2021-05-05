import json
import datetime
import time
from firebase import firebase
import sys
import Adafruit_DHT           #importing adafruit
import wiringpi2 as wiringpi #importing wiringpi
from time import sleep
import RPi.GPIO as GPIO  # import GPIO
from hx711 import HX711  # import the class HX711


dt = datetime.datetime.now()


firebase = firebase.FirebaseApplication('https://containeress-835b4-default-rtdb.firebaseio.com/', None)
 
global realtime_data_fridge,realtime_data_kitchen,location_fridge,location_kitchen

# read refill_quantity
refill = firebase.get('/app/container/kitchen/container1/refill_quantity', '')

result_2 = firebase.get('/app/container/fridge/', '')
key, value = list(result_2.items())[0]
location_fridge ='/app/container/fridge/'+str(key)

result_0 = firebase.get('/app/container/kitchen/','')
key1, value1 = list(result_0.items())[0]
location_kitchen ='/app/container/kitchen/'+str(key1)
realtime_data_fridge ={
    'temp': 30,
    'humidity': 29,
    'status':'',
    'date':str(dt.strftime("%x")),
    'time':str(dt.strftime("%X"))
   }

realtime_data_kitchen ={
    'quantity':0.5,
    'date':str(dt.strftime("%x")),
    'time':str(dt.strftime("%X"))
   }

with open('container.json', 'w') as json_file:
    json.dump(realtime_data_fridge, json_file)   

with open('container.json') as json_file:
    realtime_data_fridge = json.load(json_file)
    
with open('container1.json', 'w') as json_file:
    json.dump(realtime_data_kitchen, json_file)   

with open('container1.json') as json_file:
    realtime_data_kitchen = json.load(json_file)

#UPDATING_DATA_TO_FIREBASE_REALTIME_DATABASE
def update_data(temp,humidity,gas,qty):
    dt = datetime.datetime.now()
    c=0
    status=''
    if gas!='ethanol':
        # 0, 13 temp for actual freshness, humidity: 85, 95
        if temp>=0 and temp<=28:
            if humidity>=85 and humidity<=95:
                c=1
            else:
                c=2
        else:
            if humidity>=85 and humidity<=95:
                c=3
            else:
                c=4
    else:
        c=5
    if c==1 or c==2:
        status='Fresh'
    elif c==3 or c==4:
        status='Consume Soon'
    else:
        status='Expired'
       
    input_data_fridge={
        'temp':temp,
        'humidity':humidity,
        'status':status,
        'date':str(dt.strftime("%x")),
        'time':str(dt.strftime("%X"))
    }
    input_data_kitchen={
        'quantity': qty,
        'date':str(dt.strftime("%x")),
        'time':str(dt.strftime("%X"))
    }
    
    realtime_data_fridge.update(input_data_fridge)
    realtime_data_kitchen.update(input_data_kitchen)
    
    for i in input_data_fridge:
        firebase.put(location_fridge,i,realtime_data_fridge[i])
        
    for j in input_data_kitchen:
        firebase.put(location_kitchen,j,realtime_data_kitchen[j])
    
    
    
    result_3 = firebase.get(location_fridge, '')
    result_4 = firebase.get(location_kitchen, '')
    
    print('Record Updated')
    print("Updated fridge container:\n",result_3)
    print("Updated kitchen container:\n",result_4)
initial = firebase.get(location_fridge, '')
initial1 = firebase.get(location_kitchen, '')
print('Initial Fridge Container\n',initial)
print('Initial Kitchen Container\n',initial1)
    
#READING_SENSOR_DATA
try:
    #GPIO_setup for MQ-3
    wiringpi.wiringPiSetupGpio()
    wiringpi.pinMode(25, 0)
    
    #GPIO setup for hx711 with LOAD CELL
    GPIO.setmode(GPIO.BCM)  # set GPIO pin mode to BCM numbering
    # Create an object hx which represents your real hx711 chip
    # Required input parameters are only 'dout_pin' and 'pd_sck_pin'
    hx = HX711(dout_pin=5, pd_sck_pin=6)
    # measure tare and save the value as offset for current channel
    # and gain selected. That means channel A and gain 128
    err = hx.zero()
    # check if successful
    if err:
        raise ValueError('Tare is unsuccessful.')

    reading = hx.get_raw_data_mean()
    if reading:  # always check if you get correct value or only False
        # now the value is close to 0
        print('Data subtracted by offset but still not converted to units:',
              reading)
    else:
        print('invalid data', reading)

    # In order to calculate the conversion ratio to some units, in my case I want grams,
    # you must have known weight.
    input('Put known weight on the scale and then press Enter')
    reading = hx.get_data_mean()
    if reading:
        print('Mean value from HX711 subtracted by offset:', reading)
        known_weight_grams = input(
            'Write how many grams it was and press Enter: ')
        try:
            value = float(known_weight_grams)
            print(value, 'grams')
        except ValueError:
            print('Expected integer or float and I have got:',
                  known_weight_grams)
        # set scale ratio for particular channel and gain which is
        # used to calculate the conversion to units. Required argument is only
        # scale ratio. Without arguments 'channel' and 'gain_A' it sets
        # the ratio for current channel and gain.
        ratio = reading / value  # calculate the ratio for channel A and gain 128
        hx.set_scale_ratio(ratio)  # set ratio for current channel
        print('Ratio is set.')
    else:
        raise ValueError('Cannot calculate mean value. Try debug mode. Variable reading:', reading)
    
     #Read data several times and return mean value
    # subtracted by offset and converted by scale ratio to
    # desired units. In my case in grams.
    print("Now, I will read data in infinite loop. To exit press 'CTRL + C'")
    input('Press Enter to begin reading')
    print('Your sensor readings are as follows: ')
    while True:
        humidity, temperature = Adafruit_DHT.read_retry(11, 23)
        print("Temp: {}, Humidity: {}".format(temperature, humidity))
        # print 'Temp: {0:0.1f} C  Humidity: {1:0.1f} %'.format(temperature, humidity)
        #gas detection from MQ-3 sensor
        my_input=wiringpi.digitalRead(25)
        if(my_input):
            print("Not Detected !")
            val="gas not found"
        else:
            val="ethanol"
            print("Alcohol Detected")
        quantity=hx.get_weight_mean(20)
        print(quantity)
        quantity= abs(quantity)/1000
        quantity = round(quantity,1)
        if quantity > refill:
            quantity = refill
        print(quantity, 'kg')
        temp=float(temperature)
        humidity=float(humidity)
        gas=str(val)
        qty=float(quantity)
        update_data(temp,humidity,gas,qty)
        time.sleep(8)
except (KeyboardInterrupt, SystemExit):
    print('Bye :)')

finally:
    GPIO.cleanup()