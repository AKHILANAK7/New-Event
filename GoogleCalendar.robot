*** Settings ***
Library  GoogleCalendar.py
Library  OperatingSystem

*** Variables ***
${SUMMARY}       Test Meeting
${DESCRIPTION}   Discuss project updates.
${START_TIME}    2025-03-03T15:30:00+05:30
${END_TIME}      2025-03-03T16:30:00+05:30

${NEW_SUMMARY}        Updated Meeting
${NEW_DESCRIPTION}    Updated project discussion.
${NEW_START_TIME}     2025-03-03T17:30:00+05:30
${NEW_END_TIME}       2025-03-03T18:30:00+05:30

*** Test Cases ***
Create Google Calendar Event
     ${EVENT_ID} =  Create Event  ${SUMMARY}  ${DESCRIPTION}  ${START_TIME}  ${END_TIME}
     Should Not Be Empty  ${EVENT_ID}
     Log  Created Event ID: ${EVENT_ID}
     Create File  event_id.txt  ${EVENT_ID}


#Update Google Calendar Event
#    ${EVENT_ID} =  Get File  event_id.txt
#    Update Event  ${EVENT_ID}  ${NEW_SUMMARY}  ${NEW_DESCRIPTION}  ${NEW_START_TIME}  ${NEW_END_TIME}
#    Log  Event Updated: ${EVENT_ID}


#Delete Google Calendar Event
#    ${EVENT_ID} =  Get File  event_id.txt
#    Delete Event  ${EVENT_ID}
#    Log  Event Deleted: ${EVENT_ID}