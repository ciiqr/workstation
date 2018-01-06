Param (
    [Alias("SaltDir")] 
    [string]$salt = $( Join-Path $env:SystemDrive 'salt' )
)

# declarations
$saltCall = Join-Path $salt 'salt-call'

# run salt highstate
& $saltCall saltutil.sync_all
& $saltCall --retcode-passthrough --state-verbose=False -l warning state.apply
