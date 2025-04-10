
# CSEPrompt

CSEPrompt is a command-line tool designed to generate structured prompts for AWS support cases, helping Cloud Support Engineers communicate effectively with AI assistants across different AWS domains.

## Features
- Interactive and command-line modes
- Structured output format
- Consistent prompt generation
- Easy-to-use interface

## Installation

1. Clone the repository:
```bash
git clone https://github.com/cdirubbio/cseprompt
cd cseprompt
```

### Run the installer:
```bash
./install.sh
```
    

    
This will install the cseprompt command in /usr/local/bin/.

## Usage
### Interactive Mode
Run the tool in interactive mode:

```    
cseprompt --in
Interactive mode enabled. Please provide the following details:
...
```
    

  
## Command-line Mode
Basic usage with required parameters:
```bash
cseprompt --domain cont --service "Amazon EKS" --issue "cluster creation failing"
```

    
Full usage with all parameters:
```bash
cseprompt --domain IAC \
          --service "CloudFormation" \
          --issue "Stack creation failed" \
          --steps "Verified IAM permissions" \
          --errors "Resource creation failed" \
          --config "Using default VPC" \
          --expected "Stack should create successfully" \
          --observed "Stack rolls back immediately"
```
    

    
Available Options
--in: Run in interactive mode
--domain: Specify AWS domain (Required if not using --in)
--service: AWS service name (Required)
--issue: Issue summary (Required)
--steps: Steps already taken to troubleshoot
--errors: Error messages or relevant logs
--config: Configuration details
--expected: Expected behavior
--observed: Observed behavior
--help, -h: Display help message

## Requirements
- Bash shell
- sudo privileges (for installation)
## Notes
- Domain codes are case-insensitive
- Use quotes for values containing spaces
- In interactive mode, all command-line parameters are ignored
- Error messages and configurations can be multi-line in interactive mode
## Support
- For issues, feature requests, or contributions, please create an issue in the repository.
