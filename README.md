# Template Python Project

## Summary

When working with tech and dealing with complex environments it helps to be organised and structured so its easy to share and find projects.

Since I often have the need to work on multiple Python projects I decided to have virtual environments and manage them with Make.

However since I use VSCode with linting, I often need to download packages so that I'm able to use black, boto3 etc.

You could create one large venv for VSCode to use as the default python interpreter but I find it better to keep envs smaller and not risk of packages colliding with each other.

Much of the makefile has been inspired from this [repo](https://gist.github.com/genyrosk/2a6e893ee72fa2737a6df243f6520a6d) so don't forget to say your thanks to the author.

## Prerequisites

This assumes you have the following installed:

- vscode
- pyenv
- pyenv-virtualenv

## Why an API example

The more I think about it I often find myself working around APIs, weather its Google Workspaces or checking the local public transport public data etc.

With this in mind I've added a basic example in the **_main_**.py with API query and response.

I also use and recommend Postman since it allows me to check that I understand the API before implementing it in code.

## Usage

### Global Workspace/Project Env

As much as I don't like using one for many there are cases like with the extension AWS boto3 which needs to be configured on a more generalised level.

1. Install the extension Python Environment Manager.

2. Create a global vscode env.

   ```bash
   pyenv virtualenv 3.9.16 --force vscode-global-3.9.16
   ```

3. Select it for each workspace/project so they default to it; "Python: Select Interpreter" and then "select at workspace level" at the bottom.

4. Install AWS boto3 extension.

5. "AWS boto3: Quick Start", by now it'll promt the vscode-global env.

6. "Install" and finally select the desired AWS services.

### Terminal Coloring

Messages echoed out on the terminal are using tput coloring in order to make sure the information is clearly presented. For more info on how to use it, please visit [this site](https://linuxcommand.org/lc3_adv_tput.php).
