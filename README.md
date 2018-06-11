# Get-Stock
[![Build Status](https://travis-ci.org/tylwright/Get-Stock.svg?branch=master)](https://travis-ci.org/tylwright/Get-Stock)

## Description
This PowerShell module utilizes the IEX Group's public/free-to-use API to query information about passed in symbols.

## How to use
```
Import-Module ./Get-Stock.psm1
```

### Return stock information about provided symbol
*Input:*
```
Get-Stock -Symbol AAPL
```
*Output:*
```
Company                        Apple Inc.
CEO                            Timothy D. Cook
Industry                       Computer Hardware
Website                        http://www.apple.com
-                              -
Open                           188.27
Close                          188.58
Price                          188.58
```

### Return specific information about provided symbol
Select parameter can take: ceo, company, website, industry, openeningPrice, closingPrice, or price.
*Input:*
```
Get-Stock -Symbol AAPL -Select CEO
```
*Output:*
```
Timothy D. Cook
```

## Requirements
There are no requirements for normal usage.

### Unit Tests
In order to perform unit tests, you'll need Pester.
```
Install-Module -Name Pester -Force -SkipPublisherCheck
Invoke-Pester
```