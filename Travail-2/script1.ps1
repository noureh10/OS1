$directory = "ICC"
$csv_file = "sample.csv"

function CheckICCFolder {
	if (!(Test-Path -Path $directory)) {
		New-Item -ItemType Directory -Path $directory
	}
}

function  GetCSVDataAndCreateFolder {
	Import-Csv -Path $csv_file | ForEach-Object {
		$student_name = $_.Nom
		$student_folder = Join-Path -Path $directory -ChildPath $student_name
		if (!(Test-Path -Path $student_folder)) {
			New-Item -ItemType Directory -Path $student_folder
		}
		foreach ($subFolder in @("documents", "telechargement", "prive")) {
			$subFolderPath = Join-Path -Path $student_folder -ChildPath $subFolder
			if (!(Test-Path -Path $subFolderPath)) {
				New-Item -ItemType Directory -Path $subFolderPath
			}
		}
	}
}

CheckICCFolder
GetCSVDataAndCreateFolder