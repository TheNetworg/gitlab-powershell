# gitlab-powershell
GitLab API for managing projects.


## Installation
```PowerShell
Find-Module -Name gitlab-powershell | Install-Module
```

## Usage

```PowerShell
Connect-GitLab -serviceroot "https://git.thenetw.org/" -token "XXXXXXXXXXXXXXXXXXXX"
```

```PowerShell
Add-GitLabProjectMember -project "X0004" -user $username
```

```PowerShell
$options = @{
    "issues_enabled"=$false;
    "merge_requests_enabled"=$false;
    "builds_enabled"=$false;
    "wiki_enabled"=$false;
    "snippets_enabled"=$false;
    "container_registry_enabled"=$false;
    "shared_runners_enabled"=$false;
}

New-GitLabProject -name "X0004" -namespace "customer" -options $options
```

```PowerShell
Remove-GitLabProject -name "X0004"
```
