import json
import datetime
from database.db import get_db_connection

def lambda_handler(event, context):
    """Prüft verfügbare Tische für ein bestimmtes Datum und gibt die Tischnummern zurück."""
    try:
        params = event.get("queryStringParameters", {}) or {}
        date = params.get("date")

        if not date:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Datum erforderlich."})
            }

        # Validierung des Datumsformats (YYYY-MM-DD)
        try:
            datetime.datetime.strptime(date, '%Y-%m-%d')
        except ValueError:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Ungültiges Datumsformat. Benutze YYYY-MM-DD."})
            }

        conn = get_db_connection()
        cursor = conn.cursor()

        # Suche nach allen nicht reservierten Tischen für das gewünschte Datum
        cursor.execute("""
            SELECT table_number, table_type, max_capacity 
            FROM cafe_tables 
            WHERE id NOT IN (SELECT table_id FROM reservations WHERE DATE(reservation_time) = %s)
            ORDER BY max_capacity ASC
        """, (date,))
        
        available_tables = cursor.fetchall()

        cursor.close()
        conn.close()

        if not available_tables:
            return {
                "statusCode": 200,
                "body": json.dumps({"message": "Keine freien Tische verfügbar.", "available_tables": []})
            }

        tables_list = [
            {"table_number": table[0], "table_type": table[1], "max_capacity": table[2]}
            for table in available_tables
        ]

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Verfügbare Tische gefunden",
                "available_tables": tables_list
            })
        }

    except Exception as e:
        print(f"Fehler: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Interner Fehler", "details": str(e)})
        }
