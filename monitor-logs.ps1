# PowerShell script to monitor Twenty CRM server logs in real-time
# This will show all error messages and database queries as they happen

Write-Host "🔍 Starting Twenty CRM Server Log Monitor" -ForegroundColor Green
Write-Host "⚡ This will show all errors and database activity in real-time" -ForegroundColor Yellow
Write-Host "📋 Press Ctrl+C to stop monitoring" -ForegroundColor Cyan
Write-Host ""

$env:PATH += ";C:\Program Files\Docker\Docker\resources\bin"

try {
    # Follow the logs in real-time, filtering for important information
    docker logs -f gardening-project-twenty-server-1 2>&1 | ForEach-Object {
        $line = $_
        
        # Highlight error messages in red
        if ($line -match "error:|ERROR|Error:|QueryFailedError|failed:|exception") {
            Write-Host $line -ForegroundColor Red
        }
        # Highlight SQL queries in blue
        elseif ($line -match "query:|SELECT|INSERT|UPDATE|DELETE|ALTER") {
            Write-Host $line -ForegroundColor Blue
        }
        # Highlight warnings in yellow
        elseif ($line -match "warn:|WARN|Warning:|warning") {
            Write-Host $line -ForegroundColor Yellow
        }
        # Show GraphQL operations in magenta
        elseif ($line -match "GraphQL|mutation|subscription") {
            Write-Host $line -ForegroundColor Magenta
        }
        # Show authentication events in green
        elseif ($line -match "auth|login|token|sign") {
            Write-Host $line -ForegroundColor Green
        }
        # Default output
        else {
            Write-Host $line
        }
    }
} catch {
    Write-Host "❌ Error monitoring logs: $($_.Exception.Message)" -ForegroundColor Red
}
