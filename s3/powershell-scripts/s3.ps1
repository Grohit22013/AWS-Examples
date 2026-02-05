Import-Module AWS.Tools.S3


$region = 'us-east-1'

$bucketName = Read-Host -Prompt 'Enter the S3 bucket name'

Write-Host "S3 : $bucketName"
Write-Host "AWS Region : $region"

#Check if the bucket really exists for the function and
#if it doesnt exists it would create a new bucket for function
function BucketExists{
    $bucket  = Get-S3Bucket -BucketName $bucketName -ErrorAction SilentlyContinue
    return $null -ne $bucket
}
if (-not (BucketExists)){
    Write-Host "Bucket does not exists..."
    New-S3Bucket -BucketName $bucketName -Region $region
}
else { 
    Write-Host "Bucket already exists..."
}


# Create a new file

$fileName = 'myfile.txt'
$fileContent = 'Hello World'
Set-Content -Path $fileName -Value $fileContent

#to write the function into the s3 bucket

Write-S3Object -BucketName $bucketName -File $fileName -Key $fileName -Region $region