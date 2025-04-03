# ADpopulation

Ce script est conçu pour automatiser la création d'utilisateurs Active Directory (AD) à partir de fichiers CSV et les ajouter à des groupes spécifiques. 


## 1. Vérification de l'existence du fichier CSV :
Le script vérifie si le fichier CSV existe à l'emplacement spécifié. Si le fichier est introuvable, un message d'erreur est affiché et la fonction s'arrête.

## 2. Importation des utilisateurs depuis le fichier CSV :
Les utilisateurs sont importés à partir du fichier CSV. Chaque ligne du CSV est supposée contenir des informations sur un utilisateur, notamment le prénom (first_name) et le nom de famille (last_name).

## 3. Génération des informations de l'utilisateur :
Le script génère un nom complet (nomComplet) et un identifiant SAM (idSAM) basé sur le prénom et le nom de famille. L'identifiant SAM est limité à 20 caractères.
Un identifiant (id) est également créé en ajoutant un domaine par défaut (@ADpopulation.lan) à l'identifiant SAM.

## 4. Création de l'utilisateur dans Active Directory :
Le script tente de créer un nouvel utilisateur dans AD avec les informations générées. Si la création échoue, un message d'erreur est affiché.

## 5. Ajout de l'utilisateur à un groupe AD :
L'utilisateur nouvellement créé est ajouté au groupe spécifié (GroupName). Si l'ajout échoue, un message d'erreur est affiché.

    