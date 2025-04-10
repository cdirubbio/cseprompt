#!/bin/bash

# Initialize variables
VERSION="1.0.0"
DOMAIN=""
SERVICE=""
ISSUE_SUMMARY=""
STEPS_TAKEN=""
ERROR_MESSAGES=""
CONFIG_DETAILS=""
EXPECTED_BEHAVIOR=""
OBSERVED_BEHAVIOR=""
INTERACTIVE=false

# Convert to uppercase
to_upper() {
  echo "$1" | tr '[:lower:]' '[:upper:]'
}
get_domain_name() {
    local domain="$1"
    if [ -z "$domain" ]; then
        echo "Unknown"
        return
    fi
    
    case "$domain" in
        "CONT") echo "Containers" ;;
        "IAC") echo "Infrastructure as Code" ;;
        "CDA") echo "Code Delivery and Analysis" ;;
        "SNC") echo "Security and Crypto" ;;
        "SIP") echo "Security Identity and Protection" ;;
        "LIN") echo "Linux" ;;
        "DMS") echo "Database Migration Service" ;;
        "DMI") echo "Developer Mobile, Messaging & IoT" ;;
        "SVLS") echo "Serverless" ;;
        "DBMY") echo "Databases MySQL" ;;
        "DBPO") echo "Databases PostgreSQL" ;;
        "DFA") echo "Data Flow Analytics" ;;
        "DIA") echo "Data Insight Analytics" ;;
        "DIST") echo "Distributed Processing" ;;
        "DBL") echo "DynamoDB and Language" ;;
        "ETL") echo "Extract, Transform and Load" ;;
        "SVO") echo "SageMaker, Vision & Other" ;;
        "EAP") echo "Enterprise Applications" ;;
        "WIN") echo "Windows" ;;
        "NETDEV") echo "Network Devices" ;;
        "NETINF") echo "Network Infrastructure" ;;
        "NETMNS") echo "Network Monitor and Scale" ;;
        *) echo "Unknown Domain" ;;
    esac
}


show_help() {
    cat << EOF
AWS Support Engineer Prompt Generator
Usage: $(basename "$0") [OPTIONS]

Generate structured prompts for AWS support cases across different domains.

Options:
    --in                 Run in interactive mode (will prompt for all fields)
    --domain DOMAIN      Specify the AWS domain (Required if not using --in)
    --service SERVICE    AWS service name (Required)
    --issue TEXT         Issue summary (Required)
    --steps TEXT         Steps already taken to troubleshoot
    --errors TEXT        Error messages or relevant logs
    --config TEXT        Configuration details
    --expected TEXT      Expected behavior
    --observed TEXT      Observed behavior
    -h, --help           Display this help message

Required Fields:
    - domain (or interactive mode)
    - service
    - issue

EOF

    echo "Available Domains:"
    printf "    %-10s - %s\n" "CODE" "DESCRIPTION"
    printf "    %-10s - %s\n" "----" "-----------"
    for domain in "${VALID_DOMAINS[@]}"; do
        printf "    %-10s - %s\n" "$domain" "$(get_domain_name "$domain")"
    done

    cat << EOF

Examples:
    # Interactive mode
    $(basename "$0") --in

    # Command-line mode with minimal required parameters
    $(basename "$0") --domain CONT --service "Amazon EKS" --issue "cluster creation failing"

    # Full command-line mode
    $(basename "$0") --domain IAC \\
                     --service "CloudFormation" \\
                     --issue "Stack creation failed" \\
                     --steps "Verified IAM permissions" \\
                     --errors "Resource creation failed" \\
                     --config "Using default VPC" \\
                     --expected "Stack should create successfully" \\
                     --observed "Stack rolls back immediately"

Notes:
    - Domain codes are case-insensitive
    - Use quotes for values containing spaces
    - In interactive mode, all other parameters are ignored
    - Error messages and configurations can be multi-line in interactive mode
EOF
}

# Valid domains
VALID_DOMAINS=(
    "CONT" "IAC" "CDA" "SNC" "SIP" "LIN"
    "DMS" "DMI" "SVLS" "DBMY" "DBPO" "DFA" 
    "DIA" "DIST" "DBL" "ETL" "SVO" "EAP" 
    "WIN" "NETDEV" "NETINF" "NETMNS"
)


# Prompt interactively
prompt_inputs() {
  echo "Interactive mode enabled. Please provide the following details:"
  read -rp "Domain (CONT, IAC, CDA, SNC, SIP, LIN, etc.): " DOMAIN
  DOMAIN=$(to_upper "$DOMAIN")
  read -rp "Service: " SERVICE
  read -rp "Issue Summary: " ISSUE_SUMMARY
  read -rp "What has been tried so far: " STEPS_TAKEN
  read -rp "Error messages/logs: " ERROR_MESSAGES
  read -rp "Relevant configurations: " CONFIG_DETAILS
  read -rp "Expected behavior: " EXPECTED_BEHAVIOR
  read -rp "Observed behavior: " OBSERVED_BEHAVIOR
}

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --help|-h) show_help; exit 0 ;;
    --in) INTERACTIVE=true ;;
    --domain) DOMAIN=$(to_upper "$2"); shift ;;
    --service) SERVICE="$2"; shift ;;
    --issue) ISSUE_SUMMARY="$2"; shift ;;
    --steps) STEPS_TAKEN="$2"; shift ;;
    --errors) ERROR_MESSAGES="$2"; shift ;;
    --config) CONFIG_DETAILS="$2"; shift ;;
    --expected) EXPECTED_BEHAVIOR="$2"; shift ;;
    --observed) OBSERVED_BEHAVIOR="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
  esac
  shift
done




# If --in is used, go full interactive and ignore other flags
if $INTERACTIVE; then
  prompt_inputs
fi

# Validate domain
if [[ -z "$DOMAIN" ]]; then
  echo "Error: --domain is a required field."
  exit 1
fi

if [[ ! " ${VALID_DOMAINS[*]} " =~ " ${DOMAIN} " ]]; then
  echo "Error: Invalid domain '$DOMAIN'. Must be one of: ${VALID_DOMAINS[*]}"
  exit 1
fi
DOMAIN_FULL_NAME=$(get_domain_name "${DOMAIN}")
# Validate required fields
if [[ -z "$SERVICE" || -z "$ISSUE_SUMMARY" ]]; then
  echo "Error: --service and --issue are required fields."
  exit 1
fi


# Output prompt
cat <<EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                                   PROMPT                                      ║
╚══════════════════════════════════════════════════════════════════════════════╝

You are an expert in AWS support for the ${DOMAIN_FULL_NAME} domain. I am a Cloud Support Engineer
working on a customer issue and need detailed, accurate assistance.

╭─────────────────── ISSUE CONTEXT ───────────────────╮
│ Service: ${SERVICE}
│ Issue Summary: ${ISSUE_SUMMARY}
│ Steps Taken: ${STEPS_TAKEN}
│ Error Messages: ${ERROR_MESSAGES}
│ Configurations: ${CONFIG_DETAILS}
│ Expected Behavior: ${EXPECTED_BEHAVIOR}
│ Observed Behavior: ${OBSERVED_BEHAVIOR}
╰──────────────────────────────────────────────────────╯

Based on this information, help me:
1. Identify potential root causes.
2. Recommend next steps for investigation or resolution.
3. Suggest AWS CLI or relevant service-specific actions I can use to validate/debug.
4. Point out any misconfigurations or anti-patterns.

If additional details are needed, let me know what to ask the customer.
╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
