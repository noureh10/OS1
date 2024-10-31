function showMenu {
    Write-Host "============== ICCTech ================"
    Write-Host "1. Gestion de personnes"
    Write-Host "2. Gestion de groupe"
	Write-Host "3. Quitter"
    Write-Host "======================================"
}

function showGroupMenu {
	Write-Host "========= Gestion de groupe =========="
	Write-Host "1. Ajouter un membre"
	Write-Host "2. Supprimer un membre"
	Write-Host "3. Retour"
	Write-Host "======================================"

}

function  showPersonMenu {
	Write-Host "======== Gestion de personnes ========"
	Write-Host "1. Ajouter une personne"
	Write-Host "2. Supprimer une personne"
	Write-Host "3. Ajouter un utilisateur à un groupe"
	Write-Host "4. Enlever un utilisateur à un groupe"
	Write-Host "5. Retour"
	Write-Host "======================================"
}

function createDirectoryTreeAndFiles {
	$FolderPath = ".\RH\Salaires"
	New-Item -ItemType Directory -Path $FolderPath -Force
	$Subfolders = @("employes","managers")
	foreach ($Subfolder in $Subfolders) {
		$SubFolderPath = Join-Path -Path $FolderPath -ChildPath $Subfolder
		New-Item -ItemType Directory -Path $SubFolderPath -Force
		$FilePath = Join-Path -Path $SubFolderPath -ChildPath "salaires.txt"
		New-Item -ItemType File -Path $FilePath -Force
	}
}

function addPerson {
	Write-Host "Voulez vous ajouter un nouvel utilisateur ?"
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		$name = Read-Host "Nom d'utilisateur"
		$fullName = Read-Host "Nom complet"
		$password = Read-Host "Mot de passe" -AsSecureString
		$description = "Utilisateur membre de l'ICC, $($fullName) alias $($name)"
		$params = @{
			Name = $name
			FullName = $fullName
			Password = $password
			Description = $description
		}
		try {
			New-LocalUser @params
		} catch {
			Write-Host "Erreur lors de la création de l'utilisateur : $($Error[0].Message)"
		}
	}
}

function removePerson {
	Write-Host "Voulez vous supprimer un utilisateur ?"
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		$name = Read-Host "Nom d'utilisateur"
		try {
			Remove-LocalUser -Name $name -Force
		} catch {
			Write-Host "Erreur lors de la suppression de l'utilisateur : $($Error[0].Message)"
		}
	}
}

function addPersonToGroup {
	Write-Host "Voulez vous ajouter  un utilisateur à un groupe ?"
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		Get-LocalUser
		$user = Read-Host "Nom de l'utilisateur"
		Get-LocalGroup
		$group = Read-Host "Nom du groupe"
		try {
			Add-LocalGroupMember -Group $group -Member $user
		} catch {
			Write-Host "Erreur lors de l'ajout du membre dans le groupe souhaite : $($Error[0].Message)" 
		}
	}
}

function removePersonToGroup {
	Write-Host "Voulez vous supprimer un utilisateur d'un groupe ?"
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		Get-LocalUser
		$user = Read-Host "Nom de l'utilisateur"
		Get-LocalGroup
		$group = Read-Host "Nom du groupe"
		try {
			Remove-LocalGroupMember -Group $group -Member $user
		} catch {
			Write-Host "Erreur lors de la suppression du membre du groupe souhaite : $($Error[0].Message)"
		}
	}
}

function addGroup {
	Write-Host "Voulez-vous ajouter un nouveau groupe ?"
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		$groupName = Read-Host "Nom du groupe"
		$description = Read-Host "Description du groupe"
		$params = @{
			Name = $groupName
			Description = $description
		}
		try {
			New-LocalGroup @params
			Write-Host "Groupe '$groupName' créé avec succès."
		} catch {
			Write-Host "Erreur lors de la création du groupe : $($Error[0].Message)"
		}
	}
}

function removeGroup {
	Write-Host "Voulez-vous supprimer un groupe existant ?"
	$input = Read-Host
	if  ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		$groupName = Read-Host "Nom du groupe à supprimer"
		try {
			Remove-LocalGroup -Name $groupName
		} catch {
			Write-Host "Erreur lors de la suppresion du groupe : $($Error[0].Message)"
		}
	}
}

function userMenu {
	$userMenuLoop = $true
	while ($userMenuLoop) {
		$input = Read-Host "Choix"
		switch ($input) {
			"1" { addPerson }
			"2" { removePerson }
			"3" { addPersonToGroup }
			"4" { removePersonToGroup }
			"5" { $userMenuLoop = $false }
			default { Write-Host "Mauvais choix, veuillez reessayer" }
		}
	}
}

function groupMenu {
	$groupLoop = $true
	while ($groupLoop) {
		showGroupMenu | Out-Null
		$input = Read-Host "Choix"
		switch ($input) {
			"1" { addGroup }
			"2" { removeGroup }
			"3" { $groupLoop = $false }
			default { Write-Host "Mauvais choix, veuillez reessayer" }
		}
	}
}

function Main {
	Write-Host "Voulez vous creer la structure dans le chemin suivant : $(Get-Location) ?" 
	$exitCondition = $true;
	$input = Read-Host
	if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
		createDirectoryTreeAndFiles | Out-Null
	}
	while ($exitCondition) {
		showMenu
		$input = Read-Host "Choix"
		switch ($input) {
			"1" { addPerson }
			"2" { groupMenu }
			"3" { $exitCondition = $false }
			default { Write-Host "Mauvais choix, veuillez reessayer" }
		}
	}
	Write-Host "Fin de tache, bonne journee !"
	exit 0
}

Main