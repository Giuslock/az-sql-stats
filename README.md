# az-sql-stats

az-sql-stats is a PowerShell program that checks the firewall settings for all SQL servers in every subscription of a tenant, and outputs the results to a CSV file.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Requirements

- PowerShell 5.0 or higher
- Azure PowerShell module
- Connect-AzAccount cmdlet

## Usage

1. Connect to Azure using the `Connect-AzAccount` cmdlet
2. Run `az-sql-stats.ps1`

By default, the program outputs a CSV file called `az-sql-stats.csv` in the current working directory. The CSV file contains the following information for each SQL server:

- Subscription Name
- Resource Group Name
- SQL Server Name
- Firewall Rule Name
- Start IP Address
- End IP Address

If you would like to specify a different output file path, you can do so by passing the `-OutputFilePath` parameter when running the program.

## Contributing

We welcome contributions from the community! If you would like to contribute to az-sql-stats, please create a pull request with your proposed changes.

If you encounter any issues or have any suggestions for improvement, please create an issue on this repository.

## License

az-sql-stats is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software as long as you include the original copyright and license notices.
