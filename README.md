
# Crack StarUML

This script is designed to remove license restrictions for **StarUML version 6.3.0**, including the removal of watermarks on exports.

## Prerequisites
1. **Node.js**  

## Initialization
```
   git clone https://github.com/SebaG20xx/Crack_StarUML_Windows.git
   cd Crack_StarUML_Windows
```   

## Usage
Run the script on PowerShell as Administrator with or without specifying the path to the StarUML installation folder.

 1. **Automatic detection of the StarUML path**:    
	 ```
    .\starUML.ps1
	```
2.  **With specified path**:
	  ```
    .\starUML.ps1 C:\Folder_of_StarUML
	```

**Output**	
```
StarUML directory provided: StarUML
[1] Navigated to C:\Program Files\StarUML\resources
[2] Checking if asar is already installed...
[3] Extracting app.asar... xx
[4] Checking StarUML version expected: 6.3.0...
[5] Copying files from C:\Users\SebaG20xx_\Documents\GitHub\Crack_StarUML_Windows\patch to C:\Program Files\StarUML\resources\app\src\engine...
[6] Packing app.asar...

StarUML successfully patched!
```
After the script successfully applied, simply restart the StarUML executable to use the patched version.
## Credit
Code forked from [Nother01](https://github.com/Nother01/Crack_StarUML)

