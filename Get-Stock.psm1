<#
    Author: Tyler Wright
    Git Repo: https://github.com/tylwright/Get-Stock
    
    .Synopsis
    Shows information regarding a particular stock

    .Parameter Symbol
    Symbol of stock you wish to get the details of
    
    .Example
    Get-Stock -Symbol AAPL
#>

function Get-Stock
{
    # Script Arguments
    param
    (
        [Parameter(Mandatory = $true, HelpMessage = "Stock symbol (ex. AAPL)")]
        [ValidateNotNullOrEmpty()]
        [string]$symbol
    )

    # Functions
    <#
        .Synopsis
        Method used to grab results of an API call
    #>
    function Get-Results
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "URL of API call")]
            [ValidateNotNullOrEmpty()]
            [string]$url
        )
        $results = Invoke-WebRequest -Uri $url
        $results = $results.Content | ConvertFrom-Json
        return $results
    }

    <#
        .Synopsis
        Gather open or close price of stock based on time given

        .Parameter Time
        Get price at open or close
        
        .Example
        Get-OpenClosePrice -Time open
        
        .Example
        Get-OpenClosePrice -Time close
    #>
    function Get-OpenClosePrice
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Check price at open or close")]
            [ValidateNotNullOrEmpty()]
            [string]$time
        )
        if ($time -eq 'close' -or $time -eq 'open')
        {
            return (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/ohlc").$time.price
        }
        else
        {
            Write-Error "Available options: open, close"
        }      
    }

    <#
        .Synopsis
        Gathers many different items from the /company API call
    #>
    function Get-StockCompanyInfo
    {
        return (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/company")
    }

    <#
        .Synopsis
        Returns CEO of company

        .Parameter results
        Returned data from Get-StockCompanyInfo
    #>
    function Get-CEO
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Results from Get-StockCompanyInfo")]
            [ValidateNotNullOrEmpty()]
            $results
        )
        return $results.CEO
    }

    <#
        .Synopsis
        Returns URL of company's website

        .Parameter results
        Returned data from Get-StockCompanyInfo
    #>
    function Get-Website
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Results from Get-StockCompanyInfo")]
            [ValidateNotNullOrEmpty()]
            $results
        )
        return $results.website
    }

    <#
        .Synopsis
        Returns company name

        .Parameter results
        Returned data from Get-StockCompanyInfo
    #>
    function Get-Name
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Results from Get-StockCompanyInfo")]
            [ValidateNotNullOrEmpty()]
            $results
        )
        return $results.companyName
    }

    <#
        .Synopsis
        Returns industry of company

        .Parameter results
        Returned data from Get-StockCompanyInfo
    #>
    function Get-Industry
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Results from Get-StockCompanyInfo")]
            [ValidateNotNullOrEmpty()]
            $results
        )
        return $results.industry
    }

    <#
        .Synopsis
        Returns description of company

        .Parameter results
        Returned data from Get-StockCompanyInfo
    #>
    function Get-Description
    {
        param
        (
            [Parameter(Mandatory = $true, HelpMessage = "Results from Get-StockCompanyInfo")]
            [ValidateNotNullOrEmpty()]
            $results
        )
        return $results.description
    }

    <#
        .Synopsis
        Returns current price of stock
    #>
    function Get-Price
    {
        return (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/price")
    }

    # If making the same API call numerous times for the same group of data, stop and just call it once here.
    # From here, take the returned data and use it anywhere you wish.
    # This saves us from having to call the API over and over for the same info.
    $results = Get-StockCompanyInfo
    
    # Start building report
    $report = [ordered]@{
        Company = Get-Name -results $results; CEO = Get-CEO -results $results; Industry = Get-Industry -results $results;
        Website = Get-Website -results $results; '-' = '-';
        Open = Get-OpenClosePrice -time open; Close = Get-OpenClosePrice -time close; Price = Get-Price;
    }
   
    # Print the report
    $report | Format-Table -HideTableHeaders
}

Export-ModuleMember -Function Get-Stock