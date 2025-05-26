# Azure-Practice

This repository contains a collection of scripts and templates for working with Microsoft Azure. It is organized for easy access to:

- **PowerShell scripts** (`.ps1`): Automate Azure tasks using Azure PowerShell.
- **Azure CLI scripts** (`.azcli`): Command-line automation for Azure resources.
- **Shell scripts** (`.sh`): Bash scripts for Azure operations (add your scripts in a `Shell Scripts/` folder).
- **ARM Templates** (`.json`): Infrastructure as Code (IaC) using Azure Resource Manager templates (add your templates in an `ARM Templates/` folder).
- **Bicep scripts** (`.bicep`): Modern IaC for Azure (add your scripts in a `Bicep/` folder).

## Structure

- `Command/Existing/100. PowerShell Scripts/` — PowerShell scripts
- `Command/Existing/101. Azure CLI Scripts/` — Azure CLI scripts
- `Shell Scripts/` — Bash scripts (create this folder if needed)
- `ARM Templates/` — ARM templates (create this folder if needed)
- `Bicep/` — Bicep scripts (create this folder if needed)

## Usage

- Review the script or template you want to use.
- Update parameters as needed for your environment.
- Run scripts using the appropriate tool (PowerShell, Azure CLI, Bash, etc.).

## Best Practices

- Store secrets securely (never commit credentials).
- Use parameterization for reusable templates/scripts.
- Follow Azure naming conventions and resource tagging.

## Contribution

Feel free to add new scripts or templates. Please organize them in the correct folder and provide comments for clarity.
