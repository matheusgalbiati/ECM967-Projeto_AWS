from device_geolocation_repository import DeviceGeolocationRepository
import json
from datetime import datetime, timedelta

class DeviceGeolocationService():
    def __init__(self):
        self.repository = DeviceGeolocationRepository()
    
    def get_device_geolocation(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        
        return self.repository.get_device_geolocation(device_id)
        
    def update_device_geolocation(self, event):
        body = json.loads(event['body'])
        
        pk = 'DEVICES#' + str(body['device_id'])
        sk = '#GEOLOCATION#'
        
        last_track_time = datetime.now()
        #corrigir fuso horário para brasil
        last_track_time = last_track_time - timedelta(hours = 3)
        # transforma datetime em string (formato aceito na tabela)
        last_track_time = last_track_time.strftime("%Y-%m-%d %H:%M:%S")
        
        # definir geolocation para o dynamo
        geolocation = {
            "PK": pk,
            "SK": sk,
            "latitude": str(body['latitude']),
            "longitude": str(body['longitude']),
            # "last_track_time": str(body['last_track_time'])
            "last_track_time": last_track_time
        }
        
        return self.repository.update_device_geolocation(geolocation)
