# Prattle PRD

## What is Prattle?

Prattle is a scm (git) based document management center. It allows people to create, edit, and access their documents from anywhere, and in any form of presentation.

All documents in prattle are stored in enhanced markdown format. Documents are organzied by projects. A project can have its own theme.

## Terminology

repo: a git repository to store the source of the document.

sandbox repo: a git repository to store the documents created by unregistered users.

## Requirements

### Project

A project is a collection of documents. All the documents in a project will be compiled against the same themes and settings.

Registered users can create projects.

To create a project, one needs to give the following info:

* project name
* project slug in url (auto generated but could be altered)
* project description (optional)

An empty index.md file and a .gitignore file will be created automatically.

Registered users can later change the project settings.

### Document

A document is a pure text file with markdown (default) or other text structure.

### Draft

### Theme

### Output

The default output is html. However, user can also choose to 

### Statistics

## Classification

### Unregistered Users

Unregistered users can read any public documents.

Unregistered users can write to sandbox repo. Everyone, as long as he knows the URL of the the document, can access the document.

The writer of the document owns a separate URL for editing the document he wrote. He can share this URL to others for editing.

### Registered Writers

As long as a user registered into the system, he/she becomes a registered writer. The services provided to the registered writer depends on the billing plan, as follows:

Features    |Free       |Personal   |Team       |Corporate
------------|-----------|-----------|-----------|---------
Disk Quota  |100MB      |Unlimited  |Unlimited  |Unlimited
Projects    |Unlimited  |Unlimited  |Unlimited  |Unlimited
Private     |0          |5/10/20    |50         |Unlimited
Collaborator|0          |5/10/20    |50         |Unlimited
Themes      |Unlimited  |Unlimited  |Unlimited  |Unlimited
PDF support |No         |Yes        |Yes        |Yes
Statistics  |Basic      |Advanced   |Advanced   |Advanced




### Priviledged Writers


### Site Administrators


### 

