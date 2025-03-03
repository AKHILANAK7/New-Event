*** Settings ***
Library  DateTime
Library  GoogleCalendar.py
Library  OperatingSystem

*** Variables ***
${SUMMARY}          Test Meeting
${DESCRIPTION}      Discuss project updates.
${NEW_SUMMARY}      Updated Meeting
${NEW_DESCRIPTION}  Updated project discussion.

*** Test Cases ***
Create Google Calendar Event
    ${CURRENT_DATE} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S%z
    ${START_TIME} =      Add Time To Date    ${CURRENT_DATE}    1 hours    result_format=%Y-%m-%dT%H:%M:%S%z
    ${END_TIME} =        Add Time To Date    ${START_TIME}      1 hours    result_format=%Y-%m-%dT%H:%M:%S%z

    ${EVENT_ID} =  Create Event  ${SUMMARY}  ${DESCRIPTION}  ${START_TIME}  ${END_TIME}
    Should Not Be Empty  ${EVENT_ID}
    Log  Created Event ID: ${EVENT_ID}
    Create File  event_id.txt  ${EVENT_ID}

Update Google Calendar Event
    ${CURRENT_DATE} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S%z
    ${NEW_START_TIME} =  Add Time To Date    ${CURRENT_DATE}    3 hours    result_format=%Y-%m-%dT%H:%M:%S%z
    ${NEW_END_TIME} =    Add Time To Date    ${NEW_START_TIME}  1 hours    result_format=%Y-%m-%dT%H:%M:%S%z

    ${EVENT_ID} =  Get File  event_id.txt
    Update Event  ${EVENT_ID}  ${NEW_SUMMARY}  ${NEW_DESCRIPTION}  ${NEW_START_TIME}  ${NEW_END_TIME}
    Log  Event Updated: ${EVENT_ID}

Delete Google Calendar Event
    ${EVENT_ID} =  Get File  event_id.txt
    Delete Event  ${EVENT_ID}
    Log  Event Deleted: ${EVENT_ID}
