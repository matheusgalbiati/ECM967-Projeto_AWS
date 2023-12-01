from users_service import UsersService
import json

def lambda_handler(event, context):
    # método HTTP
    http_method = event['httpMethod']
    # verificar qual o caso de uso da requisição
    req_option = event['pathParameters']['proxy'].split('/')[0]
    
    # instanciar o users service
    service = UsersService()
    
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
    
    # Cadastrar usuário
    if http_method == 'POST' and req_option == 'create':
        return service.create_user(event)
    
    # Logar usuário
    if http_method == 'POST' and req_option == 'login':
        return service.login_user(event)
    
    # Obter usuário
    if http_method == 'GET' and req_option == 'infos':
        return service.get_user(event)
    
    # Atualizar infos usuário
    if http_method == 'PUT' and req_option == 'update':
        return service.update_user(event)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Retorno final: Users Lambda')
    }
