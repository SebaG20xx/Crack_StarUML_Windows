
# StarUMLCrack

This script is designed to remove license restrictions for **StarUML version 6.2.2**, including the removal of watermarks on exports.

## Prerequisites
1.  **Sudo Permissions**: Required if StarUML is installed in `/opt`.
1. **Node.js**  
3. **Bash**

## Initialization
   ```bash
   git clone git@github.com:Nother01/StarUMLCrack.git
   cd StarUMLCrack
   chmod 755 starUML.sh
```   

## Usage
Run the script with or without specifying the path to the StarUML installation folder, 

 1. **Automatic detection of the StarUML path**:    
	 ```
    sudo ./starUML.sh
	```
2.  **With specified path**:
	  ```
    sudo ./starUML.sh /path/to/StarUML
	```
After the script successfully applied, simply restart the StarUML executable to use the patched version.
## Credit
Code inspired by this [post](https://gist.github.com/trandaison/40b1d83618ae8e3d2da59df8c395093a?permalink_comment_id=5079514)
