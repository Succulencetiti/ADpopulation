# Fonction pour traiter les utilisateurs à partir d'un fichier CSV
function Process-Users {
    param (
        [string]$CsvPath,    # Chemin du fichier CSV
        [string]$GroupName   # Nom du groupe (admins ou users)
    )

    # Importer les utilisateurs depuis le fichier CSV
    $users = Import-Csv -Path $CsvPath -Delimiter ","

    foreach ($user in $users) {
        $prenom = $user.first_name
        $nom = $user.last_name
        $nomComplet = $prenom + " " + $nom
        $idSAM = $prenom.substring(0, 1) + $nom
        $id = $idSAM + "ADpopulation.lan"
        $pass = ConvertTo-SecureString $user.password -AsPlaintext -Force

        # Création de l'utilisateur
        New-ADUser -Name $idSAM -DisplayName $nomComplet -GivenName $prenom -Surname $nom `
            -Path "OU=humans,OU=core,DC=ADpopulation,DC=lan" -UserPrincipalName $id `
            -AccountPassword $pass -Enabled $true

        # Ajout au groupe approprié
        Add-ADGroupMember -Identity $GroupName -Members $idSAM
    }
}

# Traitement des administrateurs
Process-Users -CsvPath "C:\Users\Administrateur\Documents\admins.csv" -GroupName "admins"

# Traitement des utilisateurs
Process-Users -CsvPath "C:\Users\Administrateur\Documents\users.csv" -GroupName "users"