
function Connect-GitLab{
    <#
        .Synopsis
        This function handles settings for connecting
        .Description
        This function creates a new share. If the specified folder does not exist, it will be created, and then shared with the specified share name.
        .Example
        Connect-GitLab -serviceroot "https://git.thenetw.org/" -token "XXXXXXXXXXXXXXXXXX"
    #>
    param(
        [string]$serviceroot,
        [string]$token
    )
    $global:serviceRoot = $serviceroot
    $global:headers = @{"PRIVATE-TOKEN"=$token}
 }


function Get-GitLabUser{
    param(
        [string]$name
    )
    return Invoke-WebRequest ($serviceRoot + "/api/v3/users?username=" + $name.Substring(0,$name.IndexOf("@"))) -Headers $headers | ConvertFrom-Json
 }

function Get-GitLabProject{
    param(
        [string]$name
    )
    return (Invoke-WebRequest ($serviceRoot + "/api/v3/projects/search/" + $name) -Headers $headers | ConvertFrom-Json)[0]
 }

 function Get-GitLabNamespace{
    param(
        [string]$name
    )
    return (Invoke-WebRequest ($serviceRoot + "/api/v3/namespaces?search=" + $name) -Headers $headers | ConvertFrom-Json)[0]
 }

function Add-GitLabProjectMember{
    param(
        [string]$project,
        [string]$user,
        [int]$level=30
    )
    $prj = Get-GitLabProject($project)
    $usr = Get-GitLabUser($user)

    $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $Parameters['id'] = $prj.id
    $Parameters['user_id'] = $usr.id
    $Parameters['access_level'] = $level

    $Request = [System.UriBuilder]($serviceRoot + '/api/v3/projects/' + $prj.id + '/members')
    $Request.Query = $Parameters.ToString()
    Invoke-WebRequest -Uri $Request.Uri -Method POST -Headers $headers | out-null
 }

function Remove-GitLabProjectMember{
    param(
        [string]$project,
        [string]$user
    )
    $prj = Get-GitLabProject($project)
    $usr = Get-GitLabUser($user)

    $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $Parameters['id'] = $prj.id
    $Parameters['user_id'] = $usr.id

    $Request = [System.UriBuilder]($serviceRoot + '/api/v3/projects/' + $prj.id + '/members/' + $usr.id)
    $Request.Query = $Parameters.ToString()
    Invoke-WebRequest -Uri $Request.Uri -Method DELETE -Headers $headers | out-null
 }

 function New-GitLabProject{
    param(
        [string]$name,
        [string]$namespace,
        $options
    )
    $nms = Get-GitLabNamespace -name $namespace

    $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $Parameters['name'] = $name
    $Parameters['namespace_id'] = $nms.id

    foreach ($key in $options.Keys){
        $Parameters[$key] = $options[$key]
     }

    $Request = [System.UriBuilder]($serviceRoot + '/api/v3/projects/')
    $Request.Query = $Parameters.ToString()
    Invoke-WebRequest -Uri $Request.Uri -Method POST -Headers $headers | out-null
 }

 function Remove-GitLabProject{
    param(
        [string]$name
    )
    $prj = Get-GitLabProject -name $name

    $Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    $Parameters['id'] = $prj.id

    $Request = [System.UriBuilder]($serviceRoot + '/api/v3/projects/' + $prj.id)
    $Request.Query = $Parameters.ToString()
    Invoke-WebRequest -Uri $Request.Uri -Method DELETE -Headers $headers | out-null
 }

Export-ModuleMember -Function 'Get-*'
Export-ModuleMember -Function 'Set-*'
Export-ModuleMember -Function 'Connect-GitLab'
Export-ModuleMember -Function 'Add-*'
Export-ModuleMember -Function 'New-*'
Export-ModuleMember -Function 'Remove-*'