$directory = "ICC"
$copy_directory = "Documents Utiles"
$max_size_mb = 50

function CopyDocumentsToStudents {
	Get-ChildItem -Path $directory -Directory | ForEach-Object {
		$student_document = Join-Path -Path $_.FullName -ChildPath "documents"
		if (Test-Path -Path $student_document) {
			Copy-Item -Path "$copy_directory\*" -Destination $student_document -Recurse -Force
		}
	}
}

function CheckFolderSize {
	Get-ChildItem -Path $directory -Directory | ForEach-Object {
		$student_folder = $_.FullName
		try {
			$folder_size = (Get-ChildItem -Path $student_folder -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
		} catch {
			Write-Output "Erreur : Impossible de calculer la taille du dossier pour $student_folder. $_"
			return
		}
		if ($folder_size -gt $max_size_mb) {
			Write-Output "Alerte : Le dossier de $($_.Name) dépasse 50 Mo"
		}
	}
}

.\script1.ps1
CopyDocumentsToStudents
CheckFolderSize