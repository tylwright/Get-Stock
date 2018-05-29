
function Get-Stock ($symbol)
{
    function Get-Results ($url)
    {
        $results = Invoke-WebRequest -Uri $url
        $results = $results.Content | ConvertFrom-Json
        return $results
    }

    function Get-OpenClosePrice ($time)
    {
        (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/ohlc").$time.price
    }

    function Get-StockCompanyInfo
    {
        # item = companyName, exchange, industry, website, description, CEO, sector
        return (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/company")
    }

    function Get-CEO ($results)
    {
        return $results.CEO
    }

    function Get-Website ($results)
    {
        return $results.website
    }

    function Get-Name ($results)
    {
        return $results.companyName
    }

    function Get-Industry ($results)
    {
        return $results.industry
    }

    function Get-Description ($results)
    {
        return $results.description
    }

    function Get-Price
    {
        return (Get-Results -url "https://api.iextrading.com/1.0/stock/${symbol}/price")
    }

    $results = Get-StockCompanyInfo

    $report = [ordered]@{
       Company = Get-Name($results); CEO = Get-CEO($results); Industry = Get-Industry($results); Website = Get-Website($results); 
        '-' = '-';
        Open = Get-OpenClosePrice -time open; Close = Get-OpenClosePrice -time close; Price = Get-Price;
    }
   
    $report | Format-Table -HideTableHeaders
}

Export-ModuleMember -Function Get-Stock