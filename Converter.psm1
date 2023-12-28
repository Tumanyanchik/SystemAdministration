function ConvertFromCsvToXlsx(){
    param(
        [Parameter (Mandatory=$true)][string] $csv_path,
        [Parameter (Mandatory=$true)][string] $xlsx_path,
        [Parameter (Mandatory=$true)][string] $delimiter
    )

    if( !(Test-Path -path $csv_path) ){
        Write-Host("Csv file $csv_path doesn't exist or couldn't get access to it")
        return
    }

    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Add(1)
    $worksheet = $workbook.worksheets.Item(1)

    #Build the QueryTables.Add command and reformat data
    $TXTConnector = ("TEXT;" + $csv_path)
    $Connector = $worksheet.QueryTables.Add($TXTConnector,$worksheet.Range("A1"))
    $query = $worksheet.QueryTables.Item($Connector.name)
    $query.TextFileOtherDelimiter = $delimiter
    $query.TextFileParseType = 1
    $query.TextFileColumnDataTypes = ,1 * $worksheet.Cells.Columns.Count
    $query.AdjustColumnWidth = 1

    #Execute & delete the import query
    $query.Refresh()
    $query.Delete()

    #Save and close Workbook as XLSX
    try {
        $workbook.SaveAs($xlsx_path, 51)
    }
    catch {
        Write-Host("Couldn't save result as $xlsx_path")
        return
    } 
    finally {
        $excel.DisplayAlerts = $False
        $excel.Quit() 
    }
    return $excel
}