#!/bin/bash

###############################################################

# OKTAtoken example 00LWzgptowsw2KNdBXZbTsTwfzlX7ebB6LzRQkL3DM
OKTAtoken="$2"
OKTAtenant="subdomain"

###############################################################


# Returns OKTA Users
# arguments: TOKEN
OKTA_getUsers () {
    local OKTAtoken=$1
    local userID=$2
    curl -k -sS --fail --retry 3 --retry-max-time 60 \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: SSWS $OKTAtoken" \
        "https://$OKTAtenant.okta.com/api/v1/users/?limit=1000"
#        "https://$OKTAtenant.okta.com/api/v1/users/$userID/users?limit=1000"
}

# Returns OKTA Groups
# arguments: TOKEN
OKTA_getGroups () {
    local OKTAtoken=$1
    local group="$2"
    curl -k -sS --fail --retry 3 --retry-max-time 60 \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: SSWS $OKTAtoken" \
        "https://$OKTAtenant.okta.com/api/v1/groups/?q=$group&limit=1000"
}

# Returns the members of an OKTA group
# arguments: TOKEN GROUP-ID
OKTA_getMembers () {
    local OKTAtoken=$1
    local groupID=$2
    curl -k -sS --fail --retry 3 --retry-max-time 60 \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: SSWS $OKTAtoken" \
        "https://$OKTAtenant.okta.com/api/v1/groups/$groupID/users?limit=1000"
}

# Returns the OKTA Managed Devices
# arguments: TOKEN
OKTA_getDevices () {
    local OKTAtoken="$1"
    curl -k -sS --fail --retry 3 --retry-max-time 60 \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: SSWS $OKTAtoken" \
        "https://$OKTAtenant-admin.okta.com/api/v1/devices?expand=user&search=managementStatus+eq+%22MAN%22"
}

if [ "$1" == "groups" ]; then
  OKTA_getGroups "$OKTAtoken" "$3"
elif [ "$1" == "members" ]; then
  OKTA_getMembers "$OKTAtoken" "$3"
elif [ "$1" == "users" ]; then
  OKTA_getUsers "$OKTAtoken" "$3"
elif [ "$1" == "devices" ]; then
  OKTA_getDevices "$OKTAtoken" "$3"
else
  echo "Usage: okta_users.sh groups|members|users|devices TOKEN"
fi
