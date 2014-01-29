---
title: Howto Setup Git-svn on Empty Path
created-at: 2014-01-28T15:35:40-08:00
updated-at: 2014-01-28T16:44:18-08:00
category: Tech
---

My university use SVN to submit projects.
But I use Git as the primary VCS and sync with Github.
So I turn to Git-svn to submit codes.

The repository has many sub directories named with the class codes.
They share one SVN log.
But I'd like to seperate into projects by subdir.
So first of all, create the subdir for the class.

    svn mkdir https:///www.cs.usfca.edu/svn/USERNAME/CLASSCODE -m "CLASSCODE init"

Init svn settings by Git-svn, and sync:

    git svn init https:///www.cs.usfca.edu/svn/USERNAME/CLASSCODE
    git svn fetch

Remote branch `git-svn` is created.
Then, use the local repo as usual.

When you want to submit the code to SVN:

    git checkout git-svn -b svn

I don't want to submit all git history to SVN which will mess up the SVN history.
So I merge with squash:

    git merge master --squash
    git commit -m 'CLASSCODE HW1 update'

Finally, push to remote:

    git svn dcommit
