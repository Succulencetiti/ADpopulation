# Fonction pour traiter les utilisateurs à partir d'un fichier CSV
function Process-Users {
    param (
        [string]$CsvPath,    # Chemin du fichier CSV
        [string]$GroupName   # Nom du groupe (admins ou users)
    )

    # Vérifier si le fichier CSV existe
    if (-Not (Test-Path -Path $CsvPath)) {
        Write-Host "Le fichier CSV '$CsvPath' est introuvable." -ForegroundColor Red
        return
    }

    # Importer les utilisateurs depuis le fichier CSV
    $users = Import-Csv -Path $CsvPath -Delimiter ","

    foreach ($user in $users) {
        # Vérifier les champs obligatoires
        if (-Not $user.first_name -or -Not $user.last_name) {
            Write-Host "Un utilisateur dans le fichier CSV a des informations manquantes." -ForegroundColor Yellow
            continue
        }

        # Récupérer les informations de l'utilisateur
        $prenom = $user.first_name
        $nom = $user.last_name
        $nomComplet = "$prenom $nom"
        $idSAM = ($prenom.Substring(0, 1) + $nom).ToLower()
        $idSAM = $idSAM.Substring(0, [Math]::Min($idSAM.Length, 20)) # Limite à 20 caractères

        $id = "$idSAM@ADpopulation.lan"

        # Génération d'un mot de passe par défaut
        $pass = ConvertTo-SecureString "P@ssw0rd!" -AsPlaintext -Force

        # Création de l'utilisateur
        try {
            New-ADUser -Name $idSAM -SamAccountName $idSAM -DisplayName $nomComplet -GivenName $prenom -Surname $nom `
                -Path "OU=humans,OU=core,DC=ADpopulation,DC=lan" -UserPrincipalName $id `
                -AccountPassword $pass -Enabled $true -PasswordNeverExpires $true
            Write-Host "Utilisateur $nomComplet créé avec succès." -ForegroundColor Green
        } catch {
            Write-Host "Erreur lors de la création de l'utilisateur $nomComplet : $_" -ForegroundColor Red
            continue
        }

        # Ajout au groupe approprié
        try {
            Add-ADGroupMember -Identity $GroupName -Members $idSAM
            Write-Host "Utilisateur $nomComplet ajouté au groupe $GroupName." -ForegroundColor Green
        } catch {
            Write-Host "Erreur lors de l'ajout de $nomComplet au groupe $GroupName : $_" -ForegroundColor Red
        }
    }
}

# Traitement des administrateurs
Process-Users -CsvPath "C:\Users\Administrateur\admins.csv" -GroupName "admins"

# Traitement des utilisateurs
Process-Users -CsvPath "C:\Users\Administrateur\users.csv" -GroupName "users"