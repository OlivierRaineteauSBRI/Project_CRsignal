# Guide to Using Git with RStudio for Non-Programmers

Welcome to this guide! You will learn how to install Git, clone a repository, and perform basic operations like commit, pull, and push using RStudio. Additionally, you will learn how to add collaborators to your project or repository and troubleshoot common issues. These steps are essential for collaborating on projects using Git.

---

## Table of Contents
1. [Install Git](#install-git)
2. [Clone a Repository](#clone-a-repository)
3. [Make a Commit](#make-a-commit)
4. [Pull: Retrieve Others' Changes](#pull-retrieve-others-changes)
5. [Push: Send Your Changes](#push-send-your-changes)
6. [Resolve Conflicts](#resolve-conflicts)
7. [Add Collaborators to Your Project or Repository](#add-collaborators-to-your-project-or-repository)
8. [Troubleshooting: Commit Issues](#troubleshooting-commit-issues)

---

## 1. Install Git

### Why Install Git?
Git is a tool that allows you to manage versions of your files. This enables you to track changes made to your files and collaborate with others.

### Installation Steps
1. **Download Git:**
   - Go to the official Git website: [https://git-scm.com/](https://git-scm.com/).
   - Click the "Download" button to download the installer suitable for your operating system (Windows, macOS, Linux).

2. **Install Git:**
   - Open the downloaded file and follow the installation instructions.
   - **Important:** During installation, make sure to check the option **"Add Git to PATH"** (or equivalent) so that Git is accessible from any terminal or command prompt.

3. **Verify Installation (OPTIONNAL) :**
   - Open a terminal or command prompt.
   - Type the following command and press Enter:
     ```sh
     git --version
     ```
   - If Git is correctly installed, you will see the Git version displayed (e.g., `git version 2.39.1`).

---

## 2. Clone a Repository

### What is Cloning?
Cloning a repository means copying a project from a server (like GitLab or GitHub) to your computer. This allows you to work locally on the project.

### Steps to Clone a Repository
1. **Get the Repository URL:**
   - Go to the project page on GitLab or GitHub.
   - Click the **"Clone"** button and copy the repository URL (HTTPS or SSH).

2. **Open RStudio:**
   - Go to `File` > `New Project`.
   - Select `Version Control`.
   - Choose `Git`.
   - Paste the repository URL you copied.
   - Choose a directory to clone the repository to on your local machine.
   - Click `Create Project`.

---

## 3. Make a Commit

### What is a Commit?
A commit is a snapshot of the current state of your files. This allows you to track changes made over time.

### Steps to Make a Commit
1. **Open Your Project in RStudio:**
   - Ensure your project is open in RStudio.

2. **Modify Your Files:**
   - Work on your files as usual in RStudio.

3. **Add Modified Files to the Index:**
   - Go to the `Git` tab at the top right of RStudio.
   - You will see a list of modified files. Check the boxes next to the files you want to add to the index.

4. **Make a Commit:**
   - Click the `Commit` button at the top of the `Git` tab.
   - In the window that opens, add a commit message describing the changes you made.
   - Click `Commit` to finalize.

---

## 4. Pull: Retrieve Others' Changes

### What is a Pull?
A pull allows you to retrieve changes made by other collaborators from the remote repository.

### Steps to Pull Changes
1. **Open Your Project in RStudio:**
   - Ensure your project is open in RStudio.

2. **Retrieve Changes:**
   - Go to the `Git` tab at the top right of RStudio.
   - Click the `Pull` button to retrieve changes from the remote repository.

---

## 5. Push: Send Your Changes

### What is a Push?
A push allows you to send your local changes to the remote repository, so others can see them.

### Steps to Push Changes
1. **Open Your Project in RStudio:**
   - Ensure your project is open in RStudio.

2. **Send Your Changes:**
   - Go to the `Git` tab at the top right of RStudio.
   - Click the `Push` button to send your changes to the remote repository.

---

## 6. Resolve Conflicts

### What is a Conflict?
A conflict occurs when two people modify the same part of a file at the same time. Git will alert you if a conflict occurs.

### Steps to Resolve a Conflict
1. **Open Your Project in RStudio:**
   - Ensure your project is open in RStudio.

2. **Identify Conflicts:**
   - If conflicts occur, RStudio will alert you.
   - Open the conflicting files in RStudio.

3. **Resolve Conflicts:**
   - Look for conflict markers in the files (`<<<<<<`, `======`, `>>>>>>`).
   - Choose the changes you want to keep and remove the conflict markers.

4. **Add Resolved Files to the Index:**
   - Go to the `Git` tab and check the boxes next to the resolved files.

5. **Make a Commit:**
   - Click the `Commit` button and add a commit message describing the conflict resolution.
   - Click `Commit` to finalize.

6. **Send Your Changes:**
   - Click the `Push` button to send the resolved changes to the remote repository.

---

## 7. Add Collaborators to Your Project or Repository

### Why Add Collaborators?
Adding collaborators allows others to contribute to your project. They will be able to clone the repository, make changes, and push their modifications back to the repository.

### Steps to Add Collaborators
1. **Go to Your Repository on GitLab or GitHub:**
   - Open your web browser and go to the repository page on GitLab or GitHub.

2. **Navigate to the Settings:**
   - On GitLab: Click on `Settings` > `Members`.
   - On GitHub: Click on `Settings` > `Manage access` > `Invite a collaborator`.

3. **Invite Collaborators:**
   - Enter the GitLab or GitHub username or email address of the person you want to invite.
   - Choose the appropriate access level (e.g., Developer, Maintainer, etc.).
   - Click `Invite` or `Add member`.

4. **Collaborators Accept the Invitation:**
   - The invited collaborators will receive an email invitation.
   - They need to accept the invitation to gain access to the repository.

---

## 8. Troubleshooting: Commit Issues

### Issue: Author Identity Unknown
If you encounter the error `Author identity unknown` when trying to make a commit, it means Git does not know your identity (name and email). You need to configure these settings.

### Steps to Resolve
1. **Open a Terminal or Command Prompt:**
   - You can do this from your operating system's start menu or search bar.

2. **Configure Your Global Identity:**
   - Run the following commands to set your global identity:
     ```sh
     git config --global user.name "Your Name"
     git config --global user.email "your.email@example.com"
     ```
   - Replace `"Your Name"` and `"your.email@example.com"` with your actual name and email address.

3. **Verify the Configuration:**
   - To ensure the configuration is correct, run:
     ```sh
     git config --global --list
     ```
   - This will display your global Git configuration, including your name and email.

4. **Try Making a Commit Again:**
   - Return to RStudio and try making a commit again. The issue should be resolved.

### Example Configuration
Here is an example of setting your global identity:
```sh
git config --global user.name "ORaineteau"
git config --global user.email "ORaineteau@gitlab.com"
```

### Contact
olivier.raineteau@inserm.fr