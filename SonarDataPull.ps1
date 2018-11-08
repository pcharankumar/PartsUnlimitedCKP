#Declare Variaqbles for files
$Date = (Get-Date).ToString("yyyyMMdd-HHmmss")
$FilePath = "D:\GiecoDemo\SonarReports\"
$FileName=$FilePath + "SonarVSTSAnalysisPR" + "_" + $Date + ".xlsx"
$LineSpace = "`r`n"
$TemphtmlFile="D:\GiecoDemo\SonarReports\temp.html"
$DataValidation = ""
$EmailExcelPath="D:\GiecoDemo\GetMail.xlsx"

#Declare Mail Variables
$Username = "jenkins@primesoft.net";
$password = "GTB&P2nW" | ConvertTo-SecureString -asPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential($username,$password)
$subject ="Bugs assigned to you"
$FromEmail = "noreply@nowhere"
$ValidationSubject ="Data NOT Found in SonarCube"
$SmtpServer = "smtp.gmail.com"
$portno="587"


#Data 1 - Pull Issues information

       #Data 1 - Pull Issues information

        #Clear Variables
        $BugURI = ""
        $BugURINew =""
        $checkData = ""
        $DataValidation =""
        $BugContent = ""
        $Data = ""
        $AuthorNames =""
        $ExcelData = ""
        $CCD = ""
        $CCEmail =""

        #$BugURI = "http://192.168.20.184:9000/api/issues/search?resolved=false&types=BUG,CODE_SMELL&fmt=json&ps=500"
        $BugURI = "http://192.168.5.7:9000/api/issues/search?projects=SonarVSTSAnalysisPR3&resolved=false&types=BUG,VULNERABILITY,CODE_SMELL&fmt=json&ps=500"
        $IssuesCheckData = (Invoke-WebRequest $BugURI -UseBasicParsing | select -ExpandProperty content | ConvertFrom-Json).paging.total

        #Check Pages Count
        $IssuesPageIndex = (Invoke-WebRequest $BugURI -UseBasicParsing  | select -ExpandProperty content | ConvertFrom-Json).paging.pageSize
        $PageCount=[math]::ceiling($IssuesCheckData/$IssuesPageIndex)
        #$PageCount

        $checkData = Invoke-WebRequest $BugURI -UseBasicParsing | select -ExpandProperty Content | ConvertFrom-Json | Select total
        $ExcelData = Import-Excel $EmailExcelPath
        #$checkData.total
        If  ($checkData.total -eq '')
        {
            $DataValidation ="No Data Found"  +  $LineSpace  + "Here is the URL which used to Pull data : " + $BugURI
            $ValidationSubject ="No Data Found in Issues"
            $DataValidation              
        }
        else 
        {

            $Count = 1
            $BugContent = @()
            while ($Count -le $PageCount) 
            {
                $BugURI = "http://192.168.5.7:9000/api/issues/search?projects=SonarVSTSAnalysisPR3&resolved=false&types=BUG,VULNERABILITY,CODE_SMELL&fmt=json&ps=500&p=$Count"
                $BugContent += Invoke-WebRequest $BugURI -UseBasicParsing | select -ExpandProperty content | ConvertFrom-Json 
                $count++
            }


            #$BugContent = Invoke-WebRequest $BugURI  | select -ExpandProperty content | ConvertFrom-Json
            $Data = $BugContent.issues | Where-Object {($_.component -notlike "*.js") } |  select @{name='Author';expression={($_.author)}},
            @{name='Project_New';expression={($_.project)}},
            @{name='Component_New';expression={($_.component).split(':')[-1]}},
            @{name='Issues';expression={($_.type)}},
            @{name='Message_New';expression={($_.message)}},
            @{name='Sev_New';expression={($_.severity)}}, 
            @{name='Status_New';expression={($_.status)}}, 
            @{name='Assignee_New';expression={($_.assinee)}}, 
            @{name='creationDate_New';expression={($_.creationDate)}}, 
            @{name='updateDate_New';expression={($_.updateDate)}}, 
            @{name='effort_New';expression={($_.effort.replace('min',''))}}, 
            @{name='TD';expression={($_.debt.replace('min',''))}},
            @{name='StartLine';expression={($_.textRange.startline)}},
            @{name='EndLine';expression={($_.textRange.endline)}},
            @{name='IssueLines';expression={($_.textRange.endline) - ($_.textRange.startline)}}
                              
           #$Data | Export-Excel -path $FileName -WorksheetName "ProjectInfo" -IncludePivotTable -PivotDataToColumn -PivotData @{"Type_New"="Count";"TD"="Sum";"MoveToEnd"=$true} -PivotRows "Author" -HideSheet "ProjectInfo"
           $Data |Export-Excel -path $FileName -WorksheetName "Issues" -TableName "IssuesData" -TableStyle Light16 -IncludePivotTable  -PivotDataToColumn -PivotData @{"Issues"="Count";"IssueLines"="Sum";"TD"="Sum"}  -PivotRows "Author","Issues" -PivotFilter "Project_New" -AutoSize  -Activate -ChartType ColumnClustered3D  -IncludePivotChart
        }

        #Send Mail if No Data Found
        IF ($DataValidation -ne '')
        {
            $ValidationTO = $ExcelData |  Select ValidationTO_email
            #$ValidationTO
            Send-MailMessage -To $ValidationTO -Subject $ValidationSubject -Body $DataValidation-BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Port $portno
        }
                
        #Send mail to authors with data
        $AuthorNames = $BugContent.issues | select author -Unique 
        
        #$AuthorNames.GetType()
        foreach ($Au in $AuthorNames)
        {
                
            If ($au.author -ne '' )
            {
                $CCD = $ExcelData | ?{$_.Author_email -in $Au.author}  | Select TeamLead_email, Manager_email 
            }
                    
            $body = $BugContent.issues | 
                    sort type | 
                    Where-Object {$_.author -eq $Au.author -and ($_.component -notlike "*.js") } | 
                    Select type,assignee,creationdate,@{name='component';expression={if ([regex]::ismatch(($_.component),"/") -eq "True") {($_.component).split('/')[-1]} elseif ([regex]::ismatch(($_.component),":") -eq "True") {($_.component).split(':')[-1]}} },message


        # Build the html from the $result
$style = @"
<style>
BODY{font-family:Calibri;font-size:12pt;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse; padding-right:5px}
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;color:white;background-color:#FFFFFF }
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;background-color:Green}
TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black}
</style>
"@

            $body |  ConvertTo-Html -Head $style | Set-Content $TemphtmlFile
            #$results | Select-Object $headerElements | ConvertTo-Html -Head $style | Set-Content $TemphtmlFile

            $AuthorName = $au.author -replace '\@','%40'

            If ($AuthorName -ne "")
            {
                $URLNEW="http://192.168.5.7:9000/project/issues?id=SonarVSTSAnalysisPR3&resolved=false&types=BUG&ps=500&authors=" + $AuthorName
                $bodynew =  "Please find below for the issues assigned to you.`n" + $LineSpace  + $LineSpace + "Click below URL for more details:" + $LineSpace + "`r`n" + $URLNEW + $LineSpace + (Get-Content $TemphtmlFile -Raw)
                Send-MailMessage -To $au.author -Subject $subject -Body $bodynew -BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Cc  ($CCD.TeamLead_email, $CCD.Manager_email) -Port $portno
            }
            else 
            {
                $URLNEW="http://192.168.5.7:9000/project/issues?id=SonarVSTSAnalysisPR3&resolved=false&types=BUG&ps=500"
                $bodynew =  "Please find below for the issues assigned to you.`n" + $LineSpace  + $LineSpace + "Click below URL for more details:" + $LineSpace + "`r`n" + $URLNEW + $LineSpace + (Get-Content $TemphtmlFile -Raw)
                Send-MailMessage -To "pkumar@primesoft.net" -Subject $subject -Body $bodynew -BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Cc  ($CCD.TeamLead_email, $CCD.Manager_email) -Port $portno        
            }

       }
        
        #Delete temporary files
        Remove-Item -Path $TemphtmlFile

#Data 2 - Pull Code Coverage Information
        
        #Clear Varibles
        $MetricContent=""
        $MetricCheckData=""

        try 
        {
            $MetricURI = "http://192.168.5.7:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR3&metricKeys=lines_to_cover,uncovered_lines&ps=500"
            #$MetricURI = "http://192.168.20.184:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR&metricKeys=lines_to_cover"
            $MetricContent = Invoke-WebRequest $MetricURI | select -ExpandProperty content | ConvertFrom-Json
            $DataValidation=""
            $MetricCheckData = (Invoke-WebRequest $MetricURI | select -ExpandProperty content | ConvertFrom-Json).paging.total
            #$MetricCheckData
            If ($MetricCheckData.total -ge 500)
            {
                $DataValidation ="Data more than 500 records in Metric- Code Coverage"  +  $LineSpace  + "Here is the URL which used to Pull data : " + $MetricURI
                $ValidationSubject ="Data more than 500 records in Metric- Code Coverage"
                $DataValidation 
            }
            elseif ($MetricCheckData.total -eq '')
            {
                $DataValidation ="No Data Found in Metric - Code Coverage"  +  $LineSpace  + "Here is the URL which used to Pull data : " + $MetricURI
                $ValidationSubject ="No Data Found in Metric - Code Coverage"
                $DataValidation              
            }
            else 
            {
                $MetricContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
                Select @{name='Project';expression={($_.key).split(':')[1]} },path -ExpandProperty measures | 
                Select Project, Path, Metric, Value | 
                Sort-Object -Property @{Expression = "Metric"; Descending = $False},@{Expression = "Value"; Descending = $true} | 
                ft Project,Path,Value -GroupBy metric

                $a = $MetricContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
                Select -ExpandProperty measures | 
                ?{$_.Metric -eq 'lines_to_cover'} | 
                Select Project,Path, @{Name ='Lines To Cover'; Expression ={$_.Value -as [int]}}  

                $b = $MetricContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
                Select -ExpandProperty measures | 
                ?{$_.Metric -eq 'uncovered_lines'} | 
                Select Project,Path, @{Name ='Uncovered Lines'; Expression ={$_.Value -as [int]}} 

                Join-Object -Left $a -Right $b -LeftJoinProperty path -RightJoinProperty path | 
                sort 'Project','Lines To Cover','Uncovered Lines' -Descending |
                Export-XLSX -Path $FileName -WorksheetName "CodeCoverage" -Table -TableStyle Light16 -AutoFit
            }
        }
        catch 
        {
            $ErrorCode=$_.Exception.Message
            $DataValidation ="Error occurred while executing Metric - Code Coverage"  + $LineSpace  + "Here is the Error Code : " + "'" + $ErrorCode + "'" + $LineSpace  + "Here is the URL which used to Pull data : " + $MetricURI
            $ValidationSubject = "Error Occurred while executing Metric - Code Coverage"
        }

        #Send Validation Mail
        IF ($DataValidation -ne '')
        {
            $ValidationTO = $ExcelData |  Select ValidationTO_email
            Send-MailMessage -To $ValidationTO -Subject $ValidationSubject -Body $DataValidation-BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Port $portno
        }

#Data 3 - Pull Duplications Information

    #Clear Varibles
    $DuplicateContent=""
    $DuplicateCheckData=""
    $PageCount=0

    try 
    {

        $DuplicateURI = "http://192.168.5.7:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR3&branch=master&metricKeys=duplicated_blocks,duplicated_lines"
        $DataValidation=""
        $DuplicateCheckData = (Invoke-WebRequest $DuplicateURI | select -ExpandProperty content | ConvertFrom-Json).paging.total
        
        #Check Pages Count
        $DuplicatePageIndex = (Invoke-WebRequest $DuplicateURI | select -ExpandProperty content | ConvertFrom-Json).paging.pageSize
        $PageCount=[math]::ceiling($DuplicateCheckData/$DuplicatePageIndex)
        $PageCount

        If ($DuplicateCheckData.total -eq '')
        {
            $DataValidation ="No Data Found in Duplication"  +  $LineSpace  + "Here is the URL which used to Pull data : " + $DuplicateURI
            $ValidationSubject ="No Data Found in Duplication"
            $DataValidation              
        }
        else 
        {
            
            $Count = 1
            $DuplicateContent = @()
            while ($Count -le $PageCount) {
                $DuplicateURI = "http://192.168.5.7:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR3&branch=master&metricKeys=duplicated_blocks,duplicated_lines&ps=100&p=$Count"
                $DuplicateContent += Invoke-WebRequest $DuplicateURI | select -ExpandProperty content | ConvertFrom-Json 
                $DuplicateContent.Count
                $count++
            }
            
            #$MetricContent.components |  ?{$_.measures -ne '{}'} | 
            $DuplicateContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select @{name='Project';expression={($_.key).split(':')[1]} }, path -ExpandProperty measures | 
            Select Project, Path, Metric, Value | 
            Sort-Object -Property @{Expression = "Metric"; Descending = $False},@{Expression = "Value"; Descending = $true} | 
            ft Path,Value -GroupBy metric
            
            $a = $DuplicateContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select -ExpandProperty measures | 
            ?{$_.Metric -eq 'duplicated_lines'} | 
            Select Project,Path, @{Name ='duplicated_lines'; Expression ={$_.Value -as [int]}}  
            
            $b = $DuplicateContent.components |  ?{$_.measures -ne '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select -ExpandProperty measures | 
            ?{$_.Metric -eq 'duplicated_blocks'} | 
            Select Project,Path, @{Name ='duplicated_blocks'; Expression ={$_.Value -as [int]}}     
        
            Join-Object -Left $a -Right $b -LeftJoinProperty path -RightJoinProperty path | 
            sort 'project','duplicated_lines','duplicated_blocks' -Descending  |
            Export-XLSX -Path $FileName -WorksheetName "Duplications" -Table -TableStyle Light16 -AutoFit
        }
    }
    catch 
    {
        $ErrorCode=$_.Exception.Message
        $DataValidation ="Error occurred while executing Duplication Information."  + $LineSpace  + "Error Code : " + "'" + $ErrorCode + "'" + $LineSpace  + "Here is the URL which used to Pull data : " + $DuplicateURI
        $ValidationSubject = "Error Occurred while executing Duplication Information"
    }

    #Send Validation Mail
    IF ($DataValidation -ne '')
    {
        $ValidationTO = $ExcelData |  Select ValidationTO_email
        Send-MailMessage -To $ValidationTO -Subject $ValidationSubject -Body $DataValidation-BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Cc $ValidationCC -Port $portno
    }

#Data 4 - Pull Complex Information
    #Clear Varibles
    $ComplexContent=""
    $ComplexCheckData=""
    $PageCount=0

    try 
    {

        $ComplexURI = "http://192.168.5.7:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR3&metricKeys=complexity,cognitive_complexity&ps=500"
        $DataValidation=""
        $ComplexCheckData = (Invoke-WebRequest $ComplexURI | select -ExpandProperty content | ConvertFrom-Json).paging.total
        
        #Check Pages Count
        $ComplexPageIndex = (Invoke-WebRequest $ComplexURI | select -ExpandProperty content | ConvertFrom-Json).paging.pageSize
        $PageCount=[math]::ceiling($ComplexCheckData/$ComplexPageIndex)
        $PageCount

        If ($ComplexCheckData.total -eq '')
        {
            $DataValidation ="No Data Found in Complex Metrics"  +  $LineSpace  + "Here is the URL which used to Pull data : " + $ComplexURI
            $ValidationSubject ="No Data Found in Complex Metrics"
            $DataValidation              
        }
        else 
        {
            
            $Count = 1
            $ComplexContent = @()
            while ($Count -le $PageCount) {
                $ComplexURI = "http://192.168.5.7:9000/api/measures/component_tree?component=SonarVSTSAnalysisPR3&metricKeys=complexity,cognitive_complexity&ps=500&p=$Count"
                $ComplexContent += Invoke-WebRequest $ComplexURI | select -ExpandProperty content | ConvertFrom-Json 
                $ComplexContent.Count
                $count++
            }
            
            #$MetricContent.components |  ?{$_.measures -ne '{}'} | 
            $ComplexContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select @{name='Project';expression={($_.key).split(':')[1]} }, path -ExpandProperty measures | 
            Select Project, Path, Metric, Value | 
            Sort-Object -Property @{Expression = "Metric"; Descending = $False},@{Expression = "Value"; Descending = $true} | 
            ft Path,Value -GroupBy metric
            
            $a = $ComplexContent.components |  ?{$_.measures -notlike '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select -ExpandProperty measures | 
            ?{$_.Metric -eq 'complexity'} | 
            Select Project,Path, @{Name ='Cyclomatic_Complexity'; Expression ={$_.Value -as [int]}}  
            
            $b = $ComplexContent.components |  ?{$_.measures -ne '{}' -and $_.path -like '*/*' -and $_.path -ne '/' -and $_.path -notlike 'src/*' -and $_.path -notlike '*.js' -and $_.path -notlike '*.UnitTests'} | 
            Select -ExpandProperty measures | 
            ?{$_.Metric -eq 'cognitive_complexity'} | 
            Select Project,Path, @{Name ='Cognitive_Complexity'; Expression ={$_.Value -as [int]}}     
        
            Join-Object -Left $a -Right $b -LeftJoinProperty path -RightJoinProperty path | 
            sort 'Project','Cyclomatic_Complexity','Cognitive_Complexity' -Descending  |
            Export-XLSX -Path $FileName -WorksheetName "Complexity" -Table -TableStyle Light16 -AutoFit
        }
    }
    catch 
    {
        $ErrorCode=$_.Exception.Message
        $DataValidation ="Error occurred while executing Complex Metrics."  + $LineSpace  + "Error Code : " + "'" + $ErrorCode + "'" + $LineSpace  + "Here is the URL which used to Pull data : " + $ComplexURI
        $ValidationSubject = "Error Occurred while executing Complex Metrics"
    }

    #Send Validation Mail
    IF ($DataValidation -ne '')
    {
        $ValidationTO = $ExcelData |  Select ValidationTO_email
        Send-MailMessage -To $ValidationTO -Subject $ValidationSubject -Body $DataValidation-BodyAsHtml -SmtpServer $SmtpServer -Credential $cred -UseSsl  -From $FromEmail -Cc $ValidationCC -Port $portno
    }
