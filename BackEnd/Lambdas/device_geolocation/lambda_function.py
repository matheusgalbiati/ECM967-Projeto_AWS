from device_geolocation_service import DeviceGeolocationService
import json

def lambda_handler(event, context):
    # método HTTP
    http_method = event['httpMethod']
    # verificar qual o caso de uso da requisição
    req_option = event['pathParameters']['proxy'].split('/')[0]
    
    # instanciar o device_geolocation service
    service = DeviceGeolocationService()
    
    # habilitar CORS preflight - OPTIONS
    if http_method == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            }
        }
    
    # Obter geolocalização do dispositivo
    if http_method == 'GET' and req_option == 'get':
        return service.get_device_geolocation(event)
    
    # Atualizar geolocalização do dispositivo
    if http_method == 'POST' and req_option == 'update':
        return service.update_device_geolocation(event)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Retorno final: Device geolocation Lambda')
    }
