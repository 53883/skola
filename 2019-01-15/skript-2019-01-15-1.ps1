# Skapa certet
$selfsigncert = New-SelfSignedCertificate `
    -Subject "CN=Sebastians Signade Cert" `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -Type CodeSigningCert `
    -CertStoreLocation Cert:\LocalMachine\My\
# Flytta certet till root
Move-Item "Cert:\LocalMachine\My\$($selfsigncert.Thumbprint)" Cert:\LocalMachine\Root


### OBS ###
# Kör detta direkt i en PowerShell-prompt med adminbehörigheter
# Verkar inte gå att köra detta i ISE, så man får öppna powershell och göra det manuellt
Set-ExecutionPolicy AllSigned
$cert = gci Cert:\LocalMachine\Root\ -CodeSigningCert | Out-GridView -PassThru
Set-AuthenticodeSignature -Certificate $cert -FilePath "C:\temp\signerat_skript.ps1"