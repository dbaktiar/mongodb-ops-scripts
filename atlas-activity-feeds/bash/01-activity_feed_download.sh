#!/bin/bash

# Generic Parameter
atlas_api_base_url=https://cloud.mongodb.com/api/atlas/v1.0

# Project / Org Specific Parameters
org_id=
project_id=

# Atlas API User Specific Parameters
# required: Project Owner or Project Data Access Read/Write roles.
project_pubkey=
project_pvtkey=

# Download Activity API Specific Parameters
clustername=


function invoke_atlas_api() {
  param_api_path="$1"
  param_user="$2"
  param_method="$3"
  param_data="$4"
  param_message="$5"

  echo "invoke_atlas_api params:"
  echo "  param_api_path: [$param_api_path]"
  echo "      param_user: [$param_user]"
  echo "    param_method: [$param_method]"
  echo "      param_data: [$param_data]"
  echo "   param_message: [$param_message]"

  if [[ "$atlas_api_base_url" == "" ]]; then
    echo "ERROR: mandatory global variable atlas_api_base_url is empty."; echo "Aborted."; return 1001
  fi
  if [[ "$param_api_path" == "" ]]; then
    echo "ERROR: mandatory parameter (1) param_api_path is empty."; echo "Aborted."; return 1002
  fi
  if [[ "$param_user" == "" ]]; then
    echo "ERROR: mandatory parameter (2) param_user is empty."; echo "Aborted."; return 1003
  fi
  if [[ "$param_method" == "" ]]; then
    echo "ERROR: mandatory parameter (3) param_method is empty."; echo "Aborted."; return 1004
  fi
  if [[ "$param_data" == "" ]]; then
    echo "ERROR: mandatory parameter (4) param_data is empty."; echo "Aborted."; return 1005
  fi
  if [[ "$param_message" == "" ]]; then
    echo "Invoking Atlas API..."
  else
    echo "Invoking Atlas API for $param_message..."
  fi
  api_url="$atlas_api_base_url$param_api_path"
  if [[ "$param_method" == "POST" ]]; then
    if [[ "$param_user" == "NOUSER" ]]; then
      response=$( curl --header "Accept: application/json" --header "Content-Type: application/json" --request $param_method "$api_url" --data "$param_data" )
    else
      response=$( curl --user "$param_user" --digest --header "Accept: application/json" --header "Content-Type: application/json" --request $param_method "$api_url" --data "$param_data" )
    fi
  else
    response=$( curl --user "$param_user" --digest --header "Accept: application/json" --header "Content-Type: application/json" --request $param_method "$api_url" )
  fi

  echo "API Response:"
  echo "-------------"
#  echo $response
  echo $response | jq -r
  echo "-------------"

  if [[ "$param_message" == "" ]]; then
    echo "Invocation of Atlas API is DONE."
  else
    echo "Invocation of Atlas API for $param_message is DONE."
  fi
}


invoke_atlas_api /groups/${project_id}/dbAccessHistory/clusters/${clustername} ${project_pubkey}:${project_pvtkey} GET "{}" "{}"

