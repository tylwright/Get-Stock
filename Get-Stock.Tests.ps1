Import-Module -Name ./Get-Stock.psm1 -Force -ErrorAction Stop


Describe "Get-Stock -Symbol AAPL" {
    Context "Check results" {
        It "CEO is Timothy D. Cook" {
            Get-Stock -Symbol AAPL | Out-String | Should -BeLike '*Timothy D. Cook*'
        }
       It "Industry is Computer Hardware" {
            Get-Stock -Symbol AAPL | Out-String | Should -BeLike '*Computer Hardware*'
       }
    }
}

Describe "Get-Stock -Symbol F" {
    Context "Check results" {
        It "CEO is James P. Hackett" {
            Get-Stock -Symbol F | Out-String | Should -BeLike '*James P. Hackett*'
        }
       It "Industry is Autos" {
            Get-Stock -Symbol F | Out-String | Should -BeLike '*Autos*'
       }
    }
}

Describe "Check acceptable inputs" {
    Context "Case sensitivity" {
        It "Lowercase 'f' for Ford" {
            { Get-Stock -Symbol f } | Should -Not -Throw
        }
        It "Uppercase 'F' for Ford" {
            { Get-Stock -Symbol F } | Should -Not -Throw
        }
    }
}

Describe "Errors" {
    Context "Stop and raise error if..." {
        It "Symbol could not be found = Error" {
            { Get-Stock -Symbol tylwright -ErrorAction Stop } | Should -Throw "Symbol (tylwright) could not be found."
        }
    }
}