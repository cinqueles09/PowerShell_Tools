Connect-AzureAD
Connect-MgGraph -Scopes "Group.ReadWrite.All"

$total=(get-content BBDD-HdR.csv | Measure-object -line).lines

for ($var=1; $var -le $total; $var++) {

    $OU = Get-Content BBDD-HdR.csv | Select-Object -First $var | Select-Object -last 1 | ForEach-Object { ([string]$_).Split(";")[0] }
    $DN = Get-Content BBDD-HdR.csv | Select-Object -First $var | Select-Object -last 1 | ForEach-Object { ([string]$_).Split(";")[1] }

    $param = @{
        description="AD-$OU"
        displayName="AD-$OU"
        mailEnabled=$false
        securityEnabled=$true
        mailNickname="HdR"
        GroupTypes="DynamicMembership"
        MembershipRule="(user.onPremisesDistinguishedName -contains ""$DN"")"
        MembershipRuleProcessingState="On"
       }

    New-MgGroup -BodyParameter $param
}