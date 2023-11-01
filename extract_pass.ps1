#Извлечение паролей из файла пользователей MDaemon 
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
Set-Location C:\users\user\Desktop\mdpass\
#Номер столбца
$cols = 'five'
#Место расположения файлов
$file1='C:\users\user\Desktop\mdpass\UserList.dat'
$file='C:\users\user\Desktop\mdpass\UserList1.dat'
$file2='C:\users\user\Desktop\mdpass\data\qw2.csv'
$file3='C:\users\user\Desktop\mdpass\data\qw3.csv'
$file4='C:\users\user\Desktop\mdpass\data\qw4.txt'
$file5='C:\users\user\Desktop\mdpass\data\qw5.csv'

# чистим выводную папку
erase C:\users\user\Desktop\mdpass\data\*

# Особенности кодировки. В фале добавляется знак == при недостаточном количестве байтов в хэше пароля. Это надо удалить
Get-Content $file1 | foreach {$_ -replace ('==','=') | add-Content $file }
# 
Import-Csv $file -Delimiter "," -Header one,two,three,four,five,six,seven,eight,nine,ten,eleven | Select $cols | Export-Csv -Path $file2 –NoTypeInformation 
Get-Content $file2 | Select-Object -Skip 1 | Set-Content $file3 -Encoding UTF8

Get-Content $file3 | foreach {$_ -replace ('"','') | add-Content $file4}

foreach ($line in Get-Content $file4) { .\MDDePass.com $line | add-Content $file5 -Encoding UTF8 }

$GC_file1=gc $file1
$GC_file5= gc $file5
#GC_file5

0..($GC_file1.Count-1)|%{ $GC_file1[$_]+";"+$GC_file5[$_]}| sc 'C:\users\user\Desktop\mdpass\final.csv'

# Удаляем лишнее

erase C:\users\user\Desktop\mdpass\data\qw*


