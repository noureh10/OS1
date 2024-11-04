function addPerson {
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

function addDirectory {
	$folderName = Read-Host "Nom du répertoire"
	if (!(Test-Path -Path $folderName)) {
		New-Item -ItemType Directory -Path $directory
	}
}

function Main {
	$loop = $true
	while ($loop) {
		Write-Host "Voulez vous ajouter un nouvel utilisateur ?"
		$input = Read-Host
		if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
			addPerson
		} else {
			$loop = $false
		}
	}
	$loop = $true
	while ($loop) {
		Write-Host "Voulez vous ajouter un nouveau répertoire ?"
		$input = Read-Host
		if ($input.toLower() -eq "oui" -or $input.toLower() -eq "o") {
			addDirectory
		} else {
			$loop = $false
		}
	}
}

Main