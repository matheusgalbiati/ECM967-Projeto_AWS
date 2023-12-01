from users_repository import UsersRepository
import json
from datetime import datetime, timedelta

class UsersService():
    def __init__(self):
        self.repository = UsersRepository()
    
    def create_user(self, event):
        body = json.loads(event['body'])
        
        # preparar os valores de PK e SK
        pk = 'USERS#' + body['user_email']
        sk = '#USER#' + body['user_email']
        
        # definir valores internos
        
        created_at = datetime.now()
        # corrigir fuso horário para brasil
        created_at = created_at - timedelta(hours = 3)
        # transformar datetime em string (formato aceito na tabela)
        created_at = created_at.strftime("%Y-%m-%d %H:%M:%S")
        
        # definir user para o dynamodb
        user = {
            "PK": pk,
            "SK": sk,
            "senha": body['senha'],
            "created_at": created_at
        }
        
        return self.repository.create_user(user)
    
    def get_user(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        
        pk = 'USERS#' + user_email
        sk = '#USER#' + user_email
        
        return self.repository.get_user(pk, sk)
    
    def login_user(self, event):
        body = json.loads(event['body'])
        
        user_email = body['user_email']
        senha = body['senha']
        
        pk = 'USERS#' + user_email
        sk = '#USER#' + user_email
        user = self.repository.get_user(pk, sk)
        user = json.loads(user['body'])
        
        user_senha = user['senha']
        if user_senha == senha:
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Headers': '*',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': '*'
                },
                'body': json.dumps('User validated successfully')
            }
        else:
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Headers': '*',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': '*'
                },
                'body': json.dumps('User validation failed')
            }
    
    def update_user(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        
        body = json.loads(event['body'])
        
        for attrib, value in body.items():
            self.repository.update_user(user_email, attrib, value)
            
        return {
            'statusCode': 200,
            'headers': {
                    'Access-Control-Allow-Headers': '*',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': '*'
                },
            'body': json.dumps('User attributes updated successfully')
        }
