# __Useful modules__

---
## __Folder Helper__ - module for work with folders
### __Functions__ 
***RemoveEmptyFolders*** - remove empty folders from source List of folders. <br>
*Parameters:* <br>
- [x] [System.Collections.Generic.List[System.String]] $Folders - folders for cleaning;<br>
- [ ] [System.Collections.Generic.List[System.String]] $Exclude - folders for exclude from cleaning;<br>

*Result:*<br> 
- `$Folders` - list of folders after clean <br>
---
## __Converter__ - module for convert files from one format to another
### __Functions__ 
***ConvertFromCsvToXlsx*** - convert files from csv to xlsx with table format.<br>
*Parameters:* <br>
- [x] [string] $csvPath - path to csv file;<br>
- [x] [string] $xlsxPath - path to xlsx file;<br>
- [x] [string] $delimiter - delimiter in csv file;<br>

*Result:* <br>
- `$excel` - new xlsx file (if converting success)<br>
- `$null` - null (if converting failed)
---