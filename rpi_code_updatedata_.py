#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import json
import datetime
import time
from firebase import firebase

dt = datetime.datetime.now()


firebase = firebase.FirebaseApplication('https://container-b8aee-default-rtdb.firebaseio.com/', None)

global realtime_data,location
location ='/realtime-data/'
realtime_data ={
    'temp': 30,
    'humidity': 29,
    'qty':0.5,
    'Freshness':'',
    'date':str(dt.strftime("%x")),
    'time':str(dt.strftime("%X"))
   }

with open('container.json', 'w') as json_file:
    json.dump(realtime_data, json_file)   

with open('container.json') as json_file:
    realtime_data = json.load(json_file)
    
result_1 = firebase.post('/realtime-data/',realtime_data)



def update_data(temp,humidity,gas,qty):
    dt = datetime.datetime.now()
    status=''
    if gas!='ethanol':
        if temp>=0 and temp<=13:
            if humidity>=85 and humidity<=95:
                status='Highly Fresh'
            else:
                status='Medium Fresh'
        else:
            if humidity>=85 and humidity<=95:
                status='Medium Fresh'
            else:
                status='Less Fresh'
    else:
        status='Not Fresh'
        
    input_data={
        'temp':temp,
        'humidity':humidity,
        'qty':qty,
        'Freshness':status,
        'date':str(dt.strftime("%x")),
        'time':str(dt.strftime("%X"))
    }
    result_2 = firebase.get('/realtime-data/', '')
    key, value = list(result_2.items())[0]
    realtime_data.update(input_data)
    firebase.put(location,str(key),realtime_data)
    result_3 = firebase.get(location, '')
    print('Record Updated')
    print(result_3)
initial = firebase.get(location, '')   
print(initial)
while True:
    temp=int(input('Enter temp in degree:'))
    humidity=int(input('Enter % humidity:'))
    gas=input('Enter gas emitted:')
    qty=int(input('Enter qty:'))
    update_data(temp,humidity,gas,qty)
    time.sleep(8)

