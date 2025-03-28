import psycopg2
import os
import boto3
import json

def get_secret():
    """ Holt das Datenbank-Passwort sicher aus AWS Secrets Manager. """
    try:
        secret_arn = os.environ.get("SECRET_ARN")
        region = os.environ.get("AWS_REGION", "eu-central-1")
        if not secret_arn:
            raise ValueError("SECRET_ARN Umgebungsvariable nicht gesetzt.")

        client = boto3.client("secretsmanager", region_name=region)  
        response = client.get_secret_value(SecretId=secret_arn)
        secret = json.loads(response["SecretString"])
        return secret  

    except Exception as e:
        print(f"[FEHLER] Secrets abrufen: {str(e)}")
        raise Exception("Fehler beim Abrufen der Datenbank-Zugangsdaten.") from e

def get_db_connection():
    """ Erstellt eine Verbindung zur PostgreSQL-Datenbank mit SSL & Timeout. """
    try:
        secret = get_secret()

        conn = psycopg2.connect(
            host=os.environ.get("DB_HOST"),
            database=os.environ.get("DB_NAME"),
            user=secret.get("username"),
            password=secret.get("password"),
            sslmode='require',  
            connect_timeout=10  
        )
        print("[INFO] DB-Verbindung erfolgreich aufgebaut.")
        return conn

    except psycopg2.OperationalError as e:
        print(f"[FEHLER] DB-Verbindungsfehler: {e}")
        raise Exception("Verbindung zur Datenbank fehlgeschlagen.") from e
