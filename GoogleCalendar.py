import os
import json
import requests
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow

SCOPES = ["https://www.googleapis.com/auth/calendar"]
BASE_URL = "https://www.googleapis.com/calendar/v3/calendars/primary/events"

class GoogleCalendar():
    def __init__(self):
        self.access_token = self.get_access_token()
    def get_access_token(self):
        creds = None
        if os.path.exists("token.json"):
            creds = Credentials.from_authorized_user_file("token.json", SCOPES)
        if not creds or not creds.valid:
            flow = InstalledAppFlow.from_client_config(
                {
                    "installed": {
                        "client_id": "Your Client Id",
                        "project_id": "Project ID",
                        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                        "token_uri": "https://oauth2.googleapis.com/token",
                        "client_secret": "Secret",
                        "redirect_uris": ["http://localhost"]
                    }
                },
                SCOPES
            )
            creds = flow.run_local_server(port=0)
            with open("token.json", "w") as token:
                token.write(creds.to_json())
        return creds.token

    def create_event(self, summary, description, start_time, end_time):
        headers = {"Authorization": f"Bearer {self.access_token}", "Content-Type": "application/json"}
        event_data = {
            "summary": summary,
            "description": description,
            "start": {"dateTime": start_time, "timeZone": "Asia/Kolkata"},
            "end": {"dateTime": end_time, "timeZone": "Asia/Kolkata"},
        }

        response = requests.post(BASE_URL, headers=headers, json=event_data)
        if response.status_code == 200:
            event = response.json()
            print(f"Event Created: {event['htmlLink']}")
            return event["id"]
        else:
            print(f"Failed to create event: {response.text}")
            return None

    def update_event(self, event_id, new_summary, new_description, new_start_time, new_end_time): #Update Event
        headers = {"Authorization": f"Bearer {self.access_token}", "Content-Type": "application/json"}
        event_data = {
            "summary": new_summary,
            "description": new_description,
            "start": {"dateTime": new_start_time, "timeZone": "Asia/Kolkata"},
            "end": {"dateTime": new_end_time, "timeZone": "Asia/Kolkata"},
        }

        response = requests.put(f"{BASE_URL}/{event_id}", headers=headers, json=event_data)
        if response.status_code == 200:
            print("Event Updated Successfully")
        else:
            print(f"Failed to update event: {response.text}")

    def delete_event(self, event_id): #Delete Event
        headers = {"Authorization": f"Bearer {self.access_token}"}
        response = requests.delete(f"{BASE_URL}/{event_id}", headers=headers)

        if response.status_code == 204:
            print("Event Deleted Successfully")
        else:
            print(f"Failed to delete event: {response.text}")
