# Template - Python Project

## Summary

Often we find ourselves using the same type of environment, and in my case whenever I create Python projects I try to use Docker. However since I use VSCode with linting, I often need to download packages so that I'm able to use black, boto3 etc.

You could create one large venv for VSCode to use as the default python interpreter but I find it better to keep envs smaller and not risk of packages colliding with each other.

Much of the makefile has been inspired from this [repo](https://gist.github.com/genyrosk/2a6e893ee72fa2737a6df243f6520a6d) so don't forget to say your thanks to the author.

## Prerequisites

This assumes you have the following installed:

- vscode
- docker
- pyenv
- pyenv-virtualenv

## Why an API example

The more I think about it I often find myself working around APIs, weather its Google Workspaces or checking the local public transport public data.

With this in mind I've added a basic example in the **_main_**.py with API query and response in mind while also passing over ENV VARs for AWS into the Docker container.

Last but not least, I also use Postman more and more since it allows me to check that I understand the API before implementing it in code.

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
