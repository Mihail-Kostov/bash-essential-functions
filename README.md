bash-essential-functions
========================

Library of highly useful Bash functions. The aim is to make it easy to write cross-platform Bash scripts.

Bash Essential Functions (BEF) implements a few key features that make it easy to perform common "house-keeping" tasks in a cross-platform way. Implementing functions directly in the shell improves compatibility and performance in comparison to calling platform-specific binaries.

As a Unix shell/command language, Bash is ideally suited for the automation of other programs, or interaction with them via the command line. This is the kind of usage that BEF aims to facilitate. Bash is not a primary programming language, and the BEF library does not attempt to give it the functionality of one.

# Modules

The BEF library consists of the following files/modules:

- bef-filepaths.sh
  - functions for manipulating file paths. Normalize/canonicalize an arbitrary file path, etc.

BEF modules are independent of each other, so you only have to source the ones you need.

# Usage

## Sourcing the module

Download the required module files, and then from your script (or from the command line) call:

   ```bash
   source /path/to/bef-module.sh
   ```

This loads the contents of the module into your script (or your current shell instance), allowing you to use all the functions defined in it. Naturally, this will stop working if the module is moved or deleted, so you should consider taking the steps outlined in making your script portable.

## Using the functions

Functions in BEF modules are named like `bef_modabbr__function_name` (where "modabbr" is an abbreviation of the module name) to avoid polluting the global namespace. You can use the functions as you would use any Bash function. Some functions take arguments, and some even allow data to be piped in from STDIN:

   ```bash
   pipeline  |  bef_modabbr__function_name  $1  $2  $3...
   ```

If you want to save the output of a BEF function in a variable then it is possible (but not always a good idea) to use the familiar command substitution syntax:

   ```bash
myvar="$(bef_modabbr__function_name "${arg}")"  # usually OK, but not always!
   ```

However, command substitution spawns a subshell, which lowers performance, and strips trailing newline characters from the output of the command inside the shell. Sometimes this is unavoidable, and very often it doesn't matter much anyway, but in situations where it could potentially matter BEF provides special "setvar" functions to set a corresponding variable with the output of the command:

   ```bash
   local funcvar
   bef_modabbr__setvar_funcvar "${arg}" # faster & safer!
   ```

Using the setvar function avoids spawning a subshell and ensures that all characters of the function's output are passed into the variable. It is possible for a single function to set multiple variables using this method.

Take a look at the function definitions in the source for more details on how to use a particular function.

## Making your script portable

As outlined above, one way to import a BEF module's code into your script is by sourcing the module file. Clearly this will stop working if the module is moved or deleted, or if someone attempts to run the script on a machine that does not have the module installed. You should consider taking one of the following steps:

1. Copy the BEF module into your script's code repository to keep it with the module file.

2. Copy the actual contents of the BEF module and paste into your own script file to make it self-contained.

3. Fetch the module at runtime using `curl` or `wget` - useful for adding the module to a Docker image, or when running automated builds using a hosted CI service. Make sure you fetch a specific commit or tag to ensure your script's behaviour remains consistent.
