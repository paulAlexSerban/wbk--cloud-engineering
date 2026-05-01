# Branching Strategy

## Inspiration

- https://nvie.com/posts/a-successful-git-branching-model/

## Branches

### The main branches

At the core, the development model is greatly inspired by existing models out there.
The central repo holds two main branches with an infinite lifetime:

- `master`/`main`
- `develop`
  The `master`/`main` branch at origin should be familiar to every Git user.
  Parallel to the `master`/`main` branch, another branch exists called develop.

### Supporting branches

#### Feature branch

- may branch off from: `develop`
- must merge back into: `develop`
- branch naming convention: 
  - anything except master, develop, release-_, or hotfix-_
  - update level: 'PATCH', 'MINOR', 'MAJOR'

##### Creating a feature branch

When starting work on a new feature, branch off from the develop branch.
RUN `$ git checkout -b feature/MINOR---feature-name develop` - Switched to a new branch "myFeature"

##### Incorporating a finished feature on develop

Finished features may be merged into the develop branch to definitely add them to the upcoming release:

RUN `$ git checkout develop` - Switched to branch 'develop'
RUN `$ git merge --no-ff feature/MINOR---feature-name`
RUN `$ git branch -d feature/MINOR---feature-name` - Deleted branch feature/MINOR---feature-name.
RUN `$ git push origin develop` - Push the new merged `develop` branch

- The `--no-ff` flag causes the merge to always create a new commit object, even if the merge could be performed with a fast-forward.
  This avoids losing information about the historical existence of a feature branch and groups together all commits that together added the feature.

#### Release branches

- may branch off from: `develop`
- must merge back into: `develop` and `master`
- branch naming convention: - release-${MAJOR}-${MINOR}

##### Creating a release branch

Release branches are created from the `develop` branch.
Eg. version 1.1.5 is the current production release and we have a big release coming up.
The state of develop is ready for the “next release” and we have decided that this will become version 1.2 (rather than 1.1.6 or 2.0).
So we branch off and give the release branch a name reflecting the new version number:

RUN `$ git checkout -b release-${MAJOR}-${MINOR} develop` - Switched to a new branch "release-1.2"

After creating a new branch and switching to it, we bump the version number.
This new branch may exist there for a while, until the release may be rolled out definitely. During that time, hot-fixes may be applied in this branch (rather than on the develop branch).

> NOTE
> Adding large new features here is strictly prohibited.
> They must be merged into develop, and therefore, wait for the next big release.

##### Finishing a release branch

When the state of the `release` branch is ready to become a real release, some actions need to be carried out.
First, the `release-*` branch is merged into `master`/`main` (since every commit on master is a new release by definition, remember).
Next, that commit on master must be tagged for easy future reference to this historical version.
Finally, the changes made on the release branch need to be merged back into develop, so that future releases also contain these bug fixes.

The first two steps in Git:

RUN `$ git checkout master` - Switched to branch 'master'
RUN `$ git merge --no-ff release-1.2` - Merge made by recursive.
RUN `$ git tag -a 1.2` - The release is now done, and tagged for future reference.

To keep the changes made in the release branch, we need to merge those back into develop, though. In Git:

RUN `$ git checkout develop` - Switched to branch 'develop'
RUN `$ git merge --no-ff release-1.2` - Merge made by recursive.

This step may well lead to a merge conflict (probably even, since we have changed the version number). If so, fix it and commit.
Now we are really done and the release branch may be removed, since we don’t need it anymore:
RUN `$ git branch -d release-1.2`

### Hotfix and Bugfix branches

- hotfix may branch off from: `master` or `release` and must merge back into: `develop` and `master`
- bugfix may branch off only from `develop` and must branch back into `develop`
- branch naming convention: hotfix/PATCH---myHotfix or bugfix/PATCH---myBugfix

Hotfix branches are very much like release branches in that they are also meant to prepare for a new production release, albeit unplanned. They arise from the necessity to act immediately upon an undesired state of a live production version. When a critical bug in a production version must be resolved immediately, a hotfix branch may be branched off from the corresponding tag on the master branch that marks the production version.

The essence is that work of team members (on the develop branch) can continue, while another person is preparing a quick production fix.

#### Creating `hotfix` or `bugfix` branch

Hotfix branches are created from the `master` or `release` branch.
Eg.say version 1.2 is the current production release running live and causing troubles due to a severe bug. But changes on develop are yet unstable.
We may then branch off a hotfix branch and start fixing the problem:

RUN `$ git checkout -b hotfix/PATCH---myHotfix master` - Switched to a new branch "hotfix/PATCH---myHotfix"

#### Finishing a hotfix branch

When finished, the hotfix needs to be merged back into master, but also needs to be merged back into develop, in order to safeguard that the hotfix is included in the next release as well. This is completely similar to how release branches are finished.

First, update `master` and tag the release.

RUN `$ git checkout master` - Switched to branch 'master'
RUN `$ git merge --no-ff hotfix/PATCH---myHotfix` - Merge made by recursive.
RUN `$ git tag -a 1.2.1`

The one exception to the rule here is that, when a release branch currently exists, the hotfix changes need to be merged into that release branch, instead of develop.
Back-merging the hotfix into the release branch will eventually result in the hotfix being merged into develop too, when the release branch is finished. (If work in develop immediately requires this hotfix and cannot wait for the release branch to be finished, you may safely merge the hotfix into develop now already as well.)

Finally, remove the temporary branch:Î
RUN `$ git branch -d hotfix/PATCH---myHotfix`
